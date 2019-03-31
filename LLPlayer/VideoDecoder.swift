//
//  VideoDecoder.swift
//  LLPlayer
//
//  Created by Leppard on 2019/3/29.
//  Copyright © 2019 Leppard. All rights reserved.
//

import Foundation
import VideoToolbox

class VideoDecoder {
    private var formatDesc: CMFormatDescription?
    
    private var sps: Data? {
        didSet {
            updateFormatDesc()
        }
    }
    private var pps: Data? {
        didSet {
            updateFormatDesc()
        }
    }
    
    public func decode(fromData data: Data) -> CMSampleBuffer? {
        // 将NALU的startCode替换成AVCC的lengthCode
        let avcc = ToolBox.annexToAvcc(data: data)
        guard let bytes = avcc else {
            return nil
        }
        
        let naluType: UInt8 = bytes[4] & 0x1F
        switch naluType {
        case 5:
            // I Frame
            print("I Frame")
        case 7:
            // SPS
            sps = bytes.subdata(in: 4..<bytes.count)
            print("SPS")
        case 8:
            // PPS
            pps = bytes.subdata(in: 4..<bytes.count)
            print("PPS")
            
        default:
            // Include P/B Frame
            print("Default NALU")
        }
        
        
        
        return nil
    }
    
    private func createSampleBuffer(fromAvccData data: Data) -> CMSampleBuffer? {
        let ptr = UnsafeMutablePointer<UInt8>.allocate(capacity: data.count)
        ptr.initialize(to: 0)
        data.copyBytes(to: ptr, count: data.count)
        var blockBuffer: CMBlockBuffer?
        var status = CMBlockBufferCreateWithMemoryBlock(allocator: kCFAllocatorDefault, memoryBlock: ptr, blockLength: data.count, blockAllocator: kCFAllocatorNull, customBlockSource: nil, offsetToData: 0, dataLength: data.count, flags: 0, blockBufferOut: &blockBuffer)
        
        guard status == kCMBlockBufferNoErr else {
            print("ERROR: \(#function) at \(#line) line")
            return nil
        }
        
        var sampleBuffer: CMSampleBuffer?
        status = CMSampleBufferCreateReady(allocator: kCFAllocatorDefault, dataBuffer: blockBuffer, formatDescription: formatDesc, sampleCount: 1, sampleTimingEntryCount: 0, sampleTimingArray: nil, sampleSizeEntryCount: 1, sampleSizeArray: [data.count], sampleBufferOut: &sampleBuffer)
        
        ptr.deinitialize(count: data.count)
        ptr.deallocate()
        
        return sampleBuffer
    }
    
    private func updateFormatDesc() {
        guard let s = sps, let p = pps else {
            return
        }
        let sPtr = UnsafeMutablePointer<UInt8>.allocate(capacity: s.count)
        let pPtr = UnsafeMutablePointer<UInt8>.allocate(capacity: p.count)
        sPtr.initialize(to: 0)
        pPtr.initialize(to: 0)
        s.copyBytes(to: sPtr, count: s.count)
        p.copyBytes(to: pPtr, count: p.count)
        
        let ptrs: [UnsafePointer<UInt8>] = [UnsafePointer(sPtr), UnsafePointer(pPtr)]
        let sizes: [Int] = [s.count, p.count]
        
        let status = CMVideoFormatDescriptionCreateFromH264ParameterSets(allocator: kCFAllocatorDefault, parameterSetCount: 2, parameterSetPointers: ptrs, parameterSetSizes: sizes, nalUnitHeaderLength: 4, formatDescriptionOut: &formatDesc)
        
        sPtr.deinitialize(count: s.count)
        pPtr.deinitialize(count: p.count)
        sPtr.deallocate()
        pPtr.deallocate()
        
        guard status == kCMBlockBufferNoErr else {
            print("ERROR: \(#function) at \(#line) line")
            return
        }
    }
}
