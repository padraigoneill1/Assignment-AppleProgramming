//
//  CGFloatExtension.swift
//  Assignment_PTL
//
//  Created by padraigoneill on 15/11/2015.
//  Copyright © 2015 WIT. All rights reserved.
//

import Foundation
import CoreGraphics

public extension CGFloat{
    
    public static func random() ->CGFloat{
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
        
    }
    
    public static func random(min min : CGFloat, max : CGFloat) -> CGFloat{
        
        return CGFloat.random() * (max - min) + min
    }
}
