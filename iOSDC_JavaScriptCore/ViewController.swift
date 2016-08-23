//
//  ViewController.swift
//  iOSDC_JavaScriptCore
//
//  Created by Tomohiro Kumagai on 8/17/16.
//  Copyright © 2016 EasyStyle G.K. All rights reserved.
//

import Cocoa
import JavaScriptCore

class ViewController: NSViewController {

    class Owner {
        
    }
    
    var vm = JSVirtualMachine()!
    lazy var context: JSContext = JSContext(virtualMachine: self.vm)!
    
    var owner = Owner()
    var value: JSValue?
    var managedValue: JSManagedValue?

    @IBAction func revokeOwner(sender: AnyObject!) {
    
        owner = Owner()
//        context.evaluateScript("obj = undefined")
        print("Revoke Owner")
        
//        context = JSContext(virtualMachine: vm)
    }
    
    @IBAction func check(sender: AnyObject!) {
        
        print("Check : ", context.objectForKeyedSubscript("obj"))
        print("Check value : ", value)
        print("Check managedValue : ", managedValue?.value)
    }

    @IBAction func test(sender: AnyObject!) {
        
        let obj = MyObject(v1: 500, v2: 600, v3: 800)
        
//        vm.addManagedReference(obj, withOwner: owner)
        context.setObject(obj, forKeyedSubscript: "obj" as NSString)

        let value = MyObject(v1: 4500, v2: 600, v3: 800)
        let managedValue = MyObject(v1: 5500, v2: 600, v3: 800)

        context.setObject(value, forKeyedSubscript: "value" as NSString)
        context.setObject(managedValue, forKeyedSubscript: "managedValue" as NSString)
        
        self.value = context.objectForKeyedSubscript("value")
        self.managedValue = JSManagedValue(value: context.objectForKeyedSubscript("managedValue"))
        
        vm.addManagedReference(managedValue, withOwner: owner)

        context.evaluateScript("value = undefined")
        context.evaluateScript("managedValue = undefined")
        
//        context.evaluateScript("obj = undefined")
//        vm.removeManagedReference(obj, withOwner: owner)

        print("Test : ", context.objectForKeyedSubscript("obj"))
    }
}

