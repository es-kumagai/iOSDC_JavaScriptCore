//
//  Test.swift
//  iOSDC_JavaScriptCore
//
//  Created by Tomohiro Kumagai on 8/23/16.
//  Copyright © 2016 EasyStyle G.K. All rights reserved.
//

import JavaScriptCore

let owner = Owner()

struct Owner {
    
}

internal extension String {
    
    func something() {
        
        print("B")
    }
}

extension JSContext {
    
    @discardableResult
    func evaluateURL(forResource name: String?, withExtension extname: String?, bundle: Bundle = Bundle.main) -> JSValue! {
        
        let url = bundle.url(forResource: name, withExtension: extname)!
        let code = try! String(contentsOf: url)
        
        return evaluateScript(code)
    }
    
    convenience init(urlResource name: String?, withExtension extname: String?, bundle: Bundle = Bundle.main) {
        
        self.init()!
        evaluateURL(forResource: name, withExtension: extname)
    }
}

