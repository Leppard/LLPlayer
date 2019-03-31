//
//  ToolBox.swift
//  LLPlayer
//
//  Created by Leppard on 2019/3/31.
//  Copyright © 2019 Leppard. All rights reserved.
//

import Foundation

class ToolBox {
    /// AVCC startCode is size of NALU, which is BigEndian
    static public func annexToAvcc(data: Data) -> Data? {
        guard data.count > 4 else {
            return nil
        }
        
        let size = data.count - 4
        // StartCode need to be BigEndian
        var sizeCode: UInt32 = UInt32(size).bigEndian
        var avcc: Data = Data(bytes: &sizeCode, count: MemoryLayout<UInt32>.size)
        avcc.append(data[4...])
        return avcc
    }
    
    /// Annex B startCode is 0x00000001
    static public func avccToAnnex(data: Data) -> Data? {
        guard data.count > 4 else {
            return nil
        }
        let startCode = Data(bytes: [00, 00, 00, 01])
        var annex: Data = startCode
        annex.append(data[4...])
        return annex
    }
}
