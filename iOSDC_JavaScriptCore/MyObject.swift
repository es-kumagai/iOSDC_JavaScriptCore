//
//  MyObject.swift
//  iOSDC_JavaScriptCore
//
//  Created by Tomohiro Kumagai on 8/18/16.
//  Copyright © 2016 EasyStyle G.K. All rights reserved.
//

import JavaScriptCore

@objc protocol MyObjectInterface : JSExport {

    var v1: Int { get }
    var v2: Int { get set }
    
    static func make(v1: Int, v2: Int) -> AnyObject
}

class MyObject : NSObject, MyObjectInterface {
    
    var v1: Int
    var v2: Int
    var v3: Int
    
    static func make(v1: Int, v2: Int) -> AnyObject {
        
        return self.init(v1: v1, v2: v2, v3: 500)
    }
    
    required init(v1: Int, v2: Int, v3: Int) {
        
        self.v1 = v1
        self.v2 = v2
        self.v3 = v3
    }
    
    deinit {
        
        print("Deinit (v1: \(v1), v2: \(v2), v3: \(v3))")
    }
}
