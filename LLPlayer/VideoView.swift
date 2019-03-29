//
//  VideoView.swift
//  LLPlayer
//
//  Created by Leppard on 2019/3/29.
//  Copyright © 2019 Leppard. All rights reserved.
//

import UIKit

class VideoView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .black
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
