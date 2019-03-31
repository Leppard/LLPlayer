//
//  VideoDecoder.swift
//  LLPlayer
//
//  Created by Leppard on 2019/3/29.
//  Copyright © 2019 Leppard. All rights reserved.
//

import Foundation
import VideoToolbox

struct NALUPacket {
    var size: Int
    var data: [UInt8]
}

class VideoDecoder {
    private var sampleBuffer: CMSampleBuffer?
    
    public func decode(fromData data: Data) -> CMSampleBuffer? {
        // 将NALU的startCode替换成AVCC的lengthCode
        let avcc = ToolBox.annexToAvcc(data: data)
        guard let a = avcc else {
            return nil
        }
        
        let naluType: UInt8 = a[4] & 0x1F
        switch naluType {
        case 5:
            // I Frame
            print("I Frame")
        case 7:
            // SPS
            print("SPS")
        case 8:
            // PPS
            print("PPS")
            
        default:
            // Include P/B Frame
            print("Default NALU")
        }
        
        return nil
    }
}
