//
//  CustomOperation.swift
//  iOSDC_JavaScriptCore
//
//  Created by Tomohiro Kumagai on 8/26/16.
//  Copyright © 2016 EasyStyle G.K. All rights reserved.
//

import Swift
import Foundation.NSNotification

import JavaScriptCore

infix operator *<<

protocol JavaScriptExecutable {

    var jsContext: JSContext { get }
    
    static func *<< (owner: Self, code: String) -> JSValue!
}

class SomeClass : JavaScriptExecutable {

    let jsContext = JSContext()!
    
    @discardableResult
    static func *<< (owner: SomeClass, code: String) -> JSValue! {
        
        return owner.jsContext.evaluateScript(code)
    }
    
    func doSomething() {
        
        print(self *<< "1 + 1")
    }
}

func customOperator() {

    let obj = SomeClass()
    
    obj.doSomething()
}
