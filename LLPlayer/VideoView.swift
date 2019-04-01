//
//  VideoView.swift
//  LLPlayer
//
//  Created by Leppard on 2019/3/29.
//  Copyright © 2019 Leppard. All rights reserved.
//

import UIKit
import AVFoundation

class VideoView: UIView {
    let canvas: AVSampleBufferDisplayLayer = {
        let layer = AVSampleBufferDisplayLayer()
        layer.backgroundColor = UIColor.black.cgColor
        layer.videoGravity = .resizeAspectFill
        return layer
    }()
    
    let decoder = VideoDecoder()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.addSublayer(canvas)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        canvas.frame = self.bounds
    }
    
    public func play(withData data: Data) {
        // 暂时放在主线程
        
        let sampleBuffer = decoder.decode(fromData: data)
        if let buffer = sampleBuffer {
            canvas.enqueue(buffer)
        }
    }
}
