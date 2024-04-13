//
//  AppDelegate.swift
//  iOS_Final_Project
//
//
//

import UIKit
import FirebaseCore
import SQLite3
@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var selectedURL :String = ""
    var databaseName : String = "project.db"
    var databasePath : String = ""
    var productData : [MyData] = []
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let documentPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        
        let documentsDir = documentPaths[0]
        databasePath = documentsDir.appending("/" + databaseName)
        print("location is: " + databasePath)
        
        checkAndCreateDatabase()
        readDataFromDatabase()
        return true
    }
    
    func readDataFromDatabase()
        {
            productData.removeAll()
            
            var db: OpaquePointer? = nil
            
            if sqlite3_open(self.databasePath, &db) == SQLITE_OK {
                
                print("successfully opened database at \(self.databasePath)")
                
                var queryStatement : OpaquePointer? = nil
                let queryString : String = "select * from data"
                
                if sqlite3_prepare_v2(db, queryString, -1, &queryStatement, nil) == SQLITE_OK {
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    
                    while(sqlite3_step(queryStatement) == SQLITE_ROW)
                    {
                        let id : Int = Int(sqlite3_column_int(queryStatement, 0))
                        let aproduct = sqlite3_column_text(queryStatement, 1)
                        let acode = sqlite3_column_text(queryStatement, 2)
                        let aprice = sqlite3_column_text(queryStatement, 3)
                        let cqty : Int = Int(sqlite3_column_int(queryStatement, 4))
                        let adate = String(cString: sqlite3_column_text(queryStatement, 5))
                        let cavatar = sqlite3_column_text(queryStatement, 6)
                        
                        let product = String(cString: aproduct!)
                        let code = String(cString: acode!)
                        let price = String(cString: aprice!)
                        let quanity = Int(cqty)
                        let date = dateFormatter.date(from: adate)
                        let avatar = String(cString: cavatar!)
                        
                        let data : MyData = .init()
                        data.initWithData(theRow: id, theProduct: product, theCode: code,  thePrice: price, theQuanity: quanity,theDate: date!,theAvatar: avatar)
                        productData.append(data)
                        
                        print("query result: ")
                        print("\(id) | \(product) | \(code) | \(price)| \(quanity) | \(adate) | \(avatar)")
                        
                    }
                    sqlite3_finalize(queryStatement)    // free memory
                }
                else
                {
                    if let errorMsg = sqlite3_errmsg(db).map({ String(cString: $0) }) {
                        print("Error preparing SQL statement: \(errorMsg)")
                    } else {
                        print("Unknown error preparing SQL statement")
                    }

                }
                sqlite3_close(db)
                
            }
            else
            {
                print ("unable to open database")
            }
        }
    
    func checkAndCreateDatabase(){
        var success = false
        let fileManager = FileManager.default
        success = fileManager.fileExists(atPath: databasePath)
        
        if success{
            return
        }
        
        let databasePathFromApp = Bundle.main.resourcePath?.appending("/" + databaseName)
        
        try? fileManager.copyItem(atPath: databasePathFromApp!, toPath: databasePath)
    }
    
    

    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    func insertIntoDatabase(productData : MyData) -> Bool
        {
            var db : OpaquePointer? = nil
            var returnCode : Bool = true
            
            if sqlite3_open(self.databasePath, &db) == SQLITE_OK
            {
                var insertStatement : OpaquePointer? = nil
                var insertString : String = "insert into data values(NULL, ?,?,?,?,?,?)"
                
                if sqlite3_prepare_v2(db, insertString, -1, &insertStatement, nil) == SQLITE_OK
                {
                    let productStr = productData.product! as NSString
                    let productCodeStr = productData.code! as NSString
                    let priceStr = productData.price! as NSString
                    let quanityStr = String(productData.quanity!) as NSString
                    let avatarStr = productData.avatar! as NSString
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    let dateStr = dateFormatter.string(from: productData.date!) as NSString
                                    
                    sqlite3_bind_text(insertStatement, 1, productStr.utf8String, -1, nil)
                    sqlite3_bind_text(insertStatement, 2, productCodeStr.utf8String, -1, nil)
                    sqlite3_bind_text(insertStatement, 3, priceStr.utf8String, -1, nil)
                    sqlite3_bind_text(insertStatement, 4, dateStr.utf8String, -1, nil)
                    sqlite3_bind_text(insertStatement, 5, dateStr.utf8String, -1, nil)
                    sqlite3_bind_text(insertStatement, 6, avatarStr.utf8String, -1, nil)
                    
                    if sqlite3_step(insertStatement) == SQLITE_DONE
                    {
                        let rowID = sqlite3_last_insert_rowid(db)
                        print("Successfully inserted row \(rowID)")
                    }
                    else
                    {
                        print("Could not insert row")
                        returnCode = false
                    }
                    sqlite3_finalize(insertStatement)
                    
                }
                else
                {
                    print("insert statement could not be prepared")
                    returnCode = false
                }
                sqlite3_close(db)
            }
            else
            {
                print("unable to open database")
                returnCode = false
            }
            
            return returnCode
        }
    
}
