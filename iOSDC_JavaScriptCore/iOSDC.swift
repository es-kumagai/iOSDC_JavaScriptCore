//
//  iOSDC.swift
//  iOSDC_JavaScriptCore
//
//  Created by Tomohiro Kumagai on 8/18/16.
//  Copyright © 2016 EasyStyle G.K. All rights reserved.
//

import JavaScriptCore

func iOSDC() {

    basicOperation()
    dualContext()
    globalObjects()
    compare()
    objectAndDictionary()
    undefinedTest()
    nullTest()
    standards()
    implement()
    usingBundle()
    instantiate()
    reference()
    ecma6()
    
    print("Done")
}

func ecma6() {

    print(#function)
    
    let context = JSContext()!

    print(context.evaluateScript("[for (x of [0, 1, 2]) for (y of [0, 1, 2]) x + '' + y]"))
    print(context.evaluateScript("var array2 = [for (i of [1,2,3,4,5]) if (i > 3) i]"))
    print(context.evaluateScript("var square2 = x => x * x; square2;"))
    print(context.evaluateScript("function increment(x, y = 1) { return x += y; }; increment(10);"))
}

func reference() {

    print(#function, "Start")
    
    do {
        
        let vm = JSVirtualMachine()!
        
        do {

            let context = JSContext(virtualMachine: vm)!
            
            do {
                
                let object1 = MyObject(v1: 1, v2: 3, v3: 5)
                
                print("Context にセット")
                context.setObject(object1, forKeyedSubscript: "obj1" as NSString)
                
//                print("明示的にリリース？できない")
//                vm.removeManagedReference(object, withOwner: nil)
//                context.evaluateScript("obj = undefined")
                
                print("Object をリリース")
                
                print("Object を JavaScript でセット")
                context.setObject(MyObject.self, forKeyedSubscript: "MyObject" as NSString)
                context.evaluateScript("var obj2 = MyObject.makeWithV1V2(2, 4)")
   
                context.evaluateScript("obj2 = undefined")
                
                print("インスタンスを自己管理")
                var object3 = MyObject(v1: 1, v2: 3, v3: 5) as Optional

                print("    add")
                vm.addManagedReference(object3, withOwner: owner)
                context.setObject(object1, forKeyedSubscript: "obj3" as NSString)
                
                print("obj3: ", context.objectForKeyedSubscript("obj3"))

                let imported = JSManagedValue(value: context.objectForKeyedSubscript("obj3"))
//                let imported = context.objectForKeyedSubscript("obj3")

                object3 = nil   // vm で remove しなくても開放される。
                
                print("    remove")
                vm.removeManagedReference(object3, withOwner: owner)
                
                print("obj3 v1: ", context.objectForKeyedSubscript("obj3").forProperty("v1"))
                print("imported v1: ", imported?.value.forProperty("v1"))
                
                print("    done")
            }
            
            print("Context をリリース")
        }
        
        print("VM をリリース")
    }
    
    print(#function, "End")
}

func instantiate() {
    
    print(#function)
    
    let context = JSContext()!
    
    context.setObject(Image.self, forKeyedSubscript: "Image" as NSString)
    let instance = context.evaluateScript("Image.init('picture', 0.5)")
    
    print("instance: ", instance)
}

func usingBundle() {

    print(#function)

//    let sourcePath = Bundle.main.url(forResource: "JavaScriptAPI", withExtension: "js")!
//    let sourceCode = try! String(contentsOf: sourcePath)
//    
//    let context = JSContext()!

//    context.evaluateScript(sourceCode)

    let context = JSContext(urlResource: "JavaScriptAPI", withExtension: "js")
    
    print("region", context.evaluateScript("getAttribute('region')"))
    print("unknown", context.evaluateScript("getAttribute('unknown')"))
    
    context.evaluateScript("var article = new Article('iOSDC', 'Swift で JavaScript 始めませんか？');")
    
    print("title: ", context.evaluateScript("article.title"))
    print("body: ", context.evaluateScript("article.body"))
    print("description: ", context.evaluateScript("article.getDescription()"))
    
    let article = context.evaluateScript("article")!//.toDictionary()
    
    print("getDescription: ", article.objectForKeyedSubscript("getDescription"))
    print("native func: ", article.invokeMethod("getDescription", withArguments: []))
    print("native prop: ", article.forProperty("title"))
}

func implement() {

    print(#function)
    
    let context = JSContext()!

    context.evaluateScript("var timeout = 5.0")
    
    let account: String = "@es_kumagai"
    var options1 = [] as Array<String>
    let options2 = [] as NSMutableArray
    let myObject = MyObject(v1: 5, v2: 10, v3: 25)
    
    context.setObject(account, forKeyedSubscript: "name" as NSString)
    context.setObject(options1, forKeyedSubscript: "options1" as NSString)
    context.setObject(options2, forKeyedSubscript: "options2" as NSString)
    context.setObject(myObject, forKeyedSubscript: "myObject" as NSString)
    
    context.evaluateScript("options1.push('A1')")
    context.evaluateScript("options1.push('B1')")
    context.evaluateScript("options1.push('C1')")
    context.evaluateScript("options2.push('A2')")
    context.evaluateScript("options2.push('B2')")
    context.evaluateScript("options2.push('C2')")

    print("js : myObject.v1", context.evaluateScript("myObject.v1"))
    print("js : myObject.v2", context.evaluateScript("myObject.v2"))
    print("js : myObject.v3", context.evaluateScript("myObject.v3"))

    context.evaluateScript("myObject.v2 = 1000")

    print("js : account", context.evaluateScript("'JS: ' + name"))
    
    print("js : options1", context.objectForKeyedSubscript("options1"))
    print("js : options2", context.objectForKeyedSubscript("options2"))
    print("js : myObject.v1", context.evaluateScript("myObject.v1"))
    print("js : myObject.v2", context.evaluateScript("myObject.v2"))
    print("js : myObject.v3", context.evaluateScript("myObject.v3"))
    
    print("Swift : account", account)
    print("Swift : options1", options1)
    print("Swift : options2", options2)
    print("Swift : myObject.v1", myObject.v1)
    print("Swift : myObject.v2", myObject.v2)
    print("Swift : myObject.v3", myObject.v3)
    
    options1 += [ "X" ]
    options2.add("X")
    
    myObject.v2 = 2000
    
    print("js : options1", context.objectForKeyedSubscript("options1"))
    print("js : options2", context.objectForKeyedSubscript("options2"))

    print("js : myObject.v1", context.evaluateScript("myObject.v1"))
    print("js : myObject.v2", context.evaluateScript("myObject.v2"))
    print("js : myObject.v3", context.evaluateScript("myObject.v3"))
    
    
    context.evaluateScript("var myObject2")
    context.evaluateScript("myObject2 = MyObject.makeV1V2(8, 88)")
    
    print("try 1st : myObject2", context.objectForKeyedSubscript("myObject2"))

    context.setObject(MyObject.self, forKeyedSubscript: "MyObject" as NSString)
    context.evaluateScript("myObject2 = MyObject.makeWithV1V2(8, 88)")

    print("try 2nd : myObject2", context.objectForKeyedSubscript("myObject2"))

    context.evaluateScript("var attributes = { 'name' : 'kumagai', 'region' : 'JP' }")
    context.evaluateScript("function getAttribute(name) {" +
        "    return attributes[name];" +
        "}")

    print("region", context.evaluateScript("getAttribute('region')"))
    print("unknown", context.evaluateScript("getAttribute('unknown')"))
    
    do {

        let output : @convention(block) (String) -> Void = {
            
            NSLog("\(account) : \($0)")
        }
        
        context.setObject(unsafeBitCast(output, to: AnyObject.self), forKeyedSubscript: "output" as NSString)
    }
    
    context.evaluateScript("output('JavaScript');")
    
    context.evaluateScript("function Article(title, body) {" +
        "    this.title = title;" +
        "    this.body = body;" +
        "}" +
        "" +
        "Article.prototype.getDescription = function() { return this.body.substr(0, 10); };"
    )

    context.evaluateScript("var article = new Article('iOSDC', 'Swift で JavaScript 始めませんか？');")
    
    print("title: ", context.evaluateScript("article.title"))
    print("body: ", context.evaluateScript("article.body"))
    print("description: ", context.evaluateScript("article.getDescription()"))
    
    let article = context.evaluateScript("article")!//.toDictionary()
    
    print("getDescription: ", article.objectForKeyedSubscript("getDescription"))
    print("native func: ", article.invokeMethod("getDescription", withArguments: []))
    print("native prop: ", article.forProperty("title"))
    
    
    let image = Image(name: "Profile", scale: 0.8)
    
    context.setObject(image, forKeyedSubscript: "icon" as NSString)
    
    print("icon width: ", context.evaluateScript("icon.width"))

    context.setObject(Image.self, forKeyedSubscript: "Image" as NSString)
    context.evaluateScript("var banner = Image.makeWithNameScale('picture', 0.5);")
    
    print("banner width: ", context.evaluateScript("banner.width;"))
}

func standards() {
    
    print(#function)
    
    let context = JSContext()!
    
    print("Math.PI", context.evaluateScript("Math.PI;"))
    print("Math.sqrt(100)", context.evaluateScript("Math.sqrt(100);"))
    
    do {

        context.evaluateScript("var text1 = 'ABCDXYZ';")
        context.evaluateScript("var text2 = 'ABCDXY';")

        context.evaluateScript("var regex = new RegExp('a(\\\\w*)z', 'i');")
        
        let regex = context.evaluateScript("regex;")!
        let result1 = context.evaluateScript("text1.match(regex)[1];")!
        let result2 = context.evaluateScript("text2.match(regex)[1];")!
        
        print("RegEx", regex)
        print("RegEx 1", result1)
        print("RegEx 2", result2)
        
        print("encode", context.evaluateScript("encodeURI('https://ez-net.jp/test.php?id=1000&name=%10');"))
        print("decode", context.evaluateScript("decodeURI('https://ez-net.jp/test.php?id=1000&name=%10');"))
        print("encode component", context.evaluateScript("encodeURIComponent('https://ez-net.jp/test.php?id=1000&name=%2510');"))
        print("decode component", context.evaluateScript("decodeURIComponent('https%3A%2F%2Fez-net.jp%2Ftest.php%3Fid%3D1000%26name%3D%2510');"))

        print("eval", context.evaluateScript("eval('1 + 1');"))

        print("parse int", context.evaluateScript("parseInt(1.5);"))
        print("parse float", context.evaluateScript("parseInt(5);"))
        
        print("escape", context.evaluateScript("escape('ABCあいう');"))
        
        context.evaluateScript("var now = new Date();")

        let year = context.evaluateScript("now.getFullYear();")!
        
        print("year", year)

        context.evaluateScript("var source = '{ \"name\" : \"Test\", \"value\" : 10 }';")
        context.evaluateScript("var parsed = JSON.parse(source);")

        let jsonObject = context.objectForKeyedSubscript("parsed") as Optional
        let jsonDictionary = jsonObject?.toDictionary() as? [ AnyHashable : NSObject ]
        
        print("JSON", jsonObject, jsonDictionary)
        print("JSON name", jsonDictionary?["name"])
        print("JSON value", jsonDictionary?["value"])
    }
}

func undefinedTest() {
    
    print(#function)
    
    let context = JSContext()!
    let value = context.evaluateScript("undefined;")!

    print("int32", value.toInt32())
    print("uint32", value.toUInt32())
    print("double", value.toDouble(), Double.nan)
    print("number", value.toNumber(), value.toNumber().doubleValue, value.toNumber().intValue, value.toNumber().uintValue)
    print("array", value.toArray() as Optional)
    print("dictionary", value.toDictionary() as Optional)
    print("string", value.toString())
    print("bool", value.toBool())
    print("object", value.toObject() as Optional)
    print("date", value.toDate()!, value.toDate().timeIntervalSince1970)
}

func nullTest() {
    
    print(#function)
    
    let context = JSContext()!
    let value = context.evaluateScript("null;")!
    
    print("int32", value.toInt32())
    print("uint32", value.toUInt32())
    print("double", value.toDouble(), Double.nan)
    print("number", value.toNumber(), value.toNumber().doubleValue, value.toNumber().intValue, value.toNumber().uintValue)
    print("array", value.toArray() as Optional)
    print("dictionary", value.toDictionary() as Optional)
    print("string", value.toString())
    print("bool", value.toBool())
    print("object", value.toObject() as Optional)
    print("date", value.toDate()!, value.toDate().timeIntervalSince1970)
}

func basicOperation() {
    
    print(#function)
    
    let context = JSContext()!
    
    context.evaluateScript("var v1 = 10")
    context.evaluateScript("var v2 = 20")
    context.evaluateScript("var v3 = v1 + v2")
    
    let value1: JSValue = context.objectForKeyedSubscript("v3")!
    let value2: JSValue = context.objectForKeyedSubscript("vX")!
    
    let value3: JSValue = context.evaluateScript("v1 + v2")!
    
    print("Answer = ", value1)
    print("Answer = ", value2)
    print("Answer = ", value3)
}

func compare() {
 
    print(#function)
    
    let context = JSContext()!
    
    context.evaluateScript("var v1 = 10")
    context.evaluateScript("var v2 = 20")
    
    let value1: JSValue =
        context.objectForKeyedSubscript("v1")!
    let value2: JSValue =
        context.objectForKeyedSubscript("v2")!
    
    
    if value1 == value2 {
     
        print("Y")
    }
    else {
        
        print("N")
    }
}

func dualContext() {
    
    print(#function)
    
    let contextA = JSContext()!
    let contextB = JSContext()!
    
    contextA.evaluateScript("var v1 = 10")
    contextB.evaluateScript("var v2 = 20")
    
    let a1: JSValue = contextA.objectForKeyedSubscript("v1")!
    let a2: JSValue = contextA.objectForKeyedSubscript("v2")!
    let b1: JSValue = contextB.objectForKeyedSubscript("v1")!
    let b2: JSValue = contextB.objectForKeyedSubscript("v2")!
    
    print("A", a1, a2)
    print("B", b1, b2)
}

func globalObjects() {
    
    print(#function)
    
    let context = JSContext()!
    
//    context.evaluateScript("var global = this;")
    context.evaluateScript("var items = [];")
    context.evaluateScript("for (var item in this) { items.push(item); }")
    
    print("Globals = ", context.objectForKeyedSubscript("items")!)
}

func objectAndDictionary() {
    
    print(#function)
    
    let context = JSContext()!
    
    context.evaluateScript("var object = new Object();")
    context.evaluateScript("object.name = 'Name';")
    context.evaluateScript("object.kind = 'Kind';")
    
    let object = context.objectForKeyedSubscript("object")!
    
    print("isObject", object, object.isObject)
    print("object", type(of: object.toObject()!))
    
    let dictionary = object.toDictionary()! as! [AnyHashable : String]
    
    print("object.name", dictionary["name"])
    print("object.kind", dictionary["kind"])
    print("object.other", dictionary["other"])
    
    let string = context.evaluateScript("TEST;")!
    
    print("Is string object", string.isObject)
}
