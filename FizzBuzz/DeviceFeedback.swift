//
//  DeviceFeedback.swift
//  FizzBuzz
//
//  Created by Elliot Goldman on 9/10/18.
//  Copyright © 2018 Elliot Keeler. All rights reserved.
//

import AudioToolbox.AudioServices
import Foundation
import UIKit

protocol DeviceFeedback{}

extension DeviceFeedback{
    func lightDeviceFeedback(){
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
    
    func mediumDeviceFeedback(){
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }
    
    func heavyDeviceFeedback(){
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
    }

    
}
