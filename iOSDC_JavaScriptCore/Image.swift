//
//  Image.swift
//  iOSDC_JavaScriptCore
//
//  Created by Tomohiro Kumagai on 8/18/16.
//  Copyright © 2016 EasyStyle G.K. All rights reserved.
//

import JavaScriptCore
import AppKit

@objc protocol ImageInterface : JSExport {
    
    var width: Int { get set }
    var height: Int { get set }
    
    static func make(name: String, scale: CGFloat) -> AnyObject
}

class Image : NSObject, ImageInterface {
    
    var width, height: Int
//
//    private var rawImage: NSImage
    
    class func make(name: String, scale: CGFloat) -> AnyObject {
        
        return self.init(name: name, scale: scale)
    }
    
    required init(name: String, scale: CGFloat) {
        
        width = Int(800 * scale)
        height = Int(600 * scale)
        
//        rawImage = NSImage(named: name)!
//        width = Int(rawImage.size.width * scale)
//        height = Int(rawImage.size.height * scale)
    }
}
