//
//  AnimatedPhoneView.swift
//  FizzBuzz
//
//  Created by Elliot Goldman on 9/25/18.
//  Copyright © 2018 Elliot Keeler. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class AnimatedPhoneView : UIView{
    
    let FILE_NAME = "AnimatedPhone"
    let EXTENSION = ".mp4"
    lazy var player : AVPlayer = {
        guard let url = Bundle.main.url(forResource: FILE_NAME, withExtension: EXTENSION) else {
            print("Animated Phone Video couldn't be loaded...")
            return AVPlayer()
        }
        return AVPlayer(url: url)
    }()
    lazy var playerLayer : AVPlayerLayer = {
        return AVPlayerLayer(player: player)
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupView(){
    
        playerLayer.frame = bounds
        layer.addSublayer(playerLayer)
        player.play()
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying(note:)),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
    }
    
    @objc func playerDidFinishPlaying(note: NSNotification) {
        player.seek(to: CMTime.zero)
        player.play()
    }

}
