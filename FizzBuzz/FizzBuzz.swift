//
//  FizzBbuzz.swift
//  FizzBuzz
//
//  Created by Elliot Goldman on 9/10/18.
//  Copyright © 2018 Elliot Keeler. All rights reserved.
//

import Foundation
import UIKit
protocol FizzBuzz {}

extension FizzBuzz {
    
    var storyboardName : String {
        return "Main"
    }
    
    var appDelegate : AppDelegate {
        return Self.appDelegate
    }
    
    static var appDelegate : AppDelegate {
        if let delegate = UIApplication.shared.delegate{
            return delegate as! AppDelegate
        }else{
            //To be honest I can't imagine why this would be called
            fatalError("Where's your app delegate?!")
        }
    }
    
    var audioManager : AudioManager {
        return Self.appDelegate.audioManager
    }
    
    static var audioManager : AudioManager {
        if let delegate = UIApplication.shared.delegate{
            return (delegate as! AppDelegate).audioManager
        }else{
            //To be honest I can't imagine why this would be called
            fatalError("Where's your app delegate?!")
        }
    }
    
    var mainColor : UIColor{
        //RGB: 30, 30, 56 (out of 256)
        return UIColor(red: 0.117, green: 0.117, blue: 0.219, alpha: 1.0)
    }
    
    var secondaryColor : UIColor{
        //RGB: 251, 49, 30 (out of 256)
        return UIColor(red: 0.980, green: 0.191, blue: 0.117, alpha: 1.0)
    }
    
    var tertiaryColor : UIColor{
        //RGB: 251, 199, 21 (out of 256)
        return UIColor(red: 0.980, green: 0.777, blue: 0.082, alpha: 1.0)
    }
    
    //In seconds
    var defaultStartTime : Int {
        return 12
    }
}

