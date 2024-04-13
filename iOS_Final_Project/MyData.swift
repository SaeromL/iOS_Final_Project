//
//  MyData.swift
//  iOS_Final_Project
//
//  Created by Harry Nguyen on 2024-04-11.
//

import UIKit

class MyData: NSObject {
    var id : Int?
    var product : String?
    var code : String?
    var price: String?
    var quanity: Int?
    var date: Date?
    var avatar: String?
    
    
    func initWithData(theRow i:Int, theProduct n: String,theCode c: String,thePrice g: String,theQuanity q: Int, theDate d: Date, theAvatar v:String){
        
        id = i
        product = n
        code = c
        price = g
        quanity = q
        date = d
        avatar = v
        
    }
}
