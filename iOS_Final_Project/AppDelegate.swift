//
//  AppDelegate.swift
//  iOS_Final_Project
//
//
//

import UIKit
import FirebaseCore
import FirebaseAuth
import SQLite3

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var selectedURL :String = ""
    var databaseName : String = "project.db"
    var databasePath : String = ""
    var productData : [MyData] = []
    var filteredProductData : [MyData] = []
    var db: OpaquePointer?
    
    func allProducts(){
        filteredProductData.removeAll()
        filteredProductData = productData
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Initialize Firebase
        FirebaseApp.configure()
        
        // Sign out the user if they are already authenticated
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        
        let documentPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        
        let documentsDir = documentPaths[0]
        databasePath = documentsDir.appending("/" + databaseName)
        print("location is: " + databasePath)
        
        checkAndCreateDatabase()
        readDataFromDatabase()
        
        // Set the db property of AppDelegate
        db = openDatabase()
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
                        let dateString = adate != nil ? String(cString: adate) : ""
                        let date = dateFormatter.date(from: dateString)
                        let avatar = String(cString: cavatar!)
                        
//                        let data : MyData = .init()
//                        data.initWithData(theRow: id, theProduct: product, theCode: code,  thePrice: price, theQuanity: quanity,theDate: date!,theAvatar: avatar)
//                        productData.append(data)
//                        
//                        print("query result: ")
//                        print("\(id) | \(product) | \(code) | \(price)| \(quanity) | \(adate) | \(avatar)")
                        
                        if let date = date {
                            let data = MyData()
                            data.initWithData(theRow: id, theProduct: product, theCode: code,  thePrice: price, theQuanity: quanity, theDate: date, theAvatar: avatar)
                            productData.append(data)

                            print("query result: ")
                            print("\(id) | \(product) | \(code) | \(price)| \(quanity) | \(dateString) | \(avatar)")
                        } else {
                            print("Error parsing date: \(dateString)")
                        }
                        
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
    
    

    func deleteDataFromSQLite(productData: MyData) -> Bool {
        // Open the database
        if let db = openDatabase() {
            // Construct the DELETE query
            let queryString = "DELETE FROM data WHERE id = ?;"
            
            // Prepare the DELETE statement
            var deleteStatement: OpaquePointer?
            if sqlite3_prepare_v2(db, queryString, -1, &deleteStatement, nil) == SQLITE_OK {
                // Bind the primary key value to the statement
                sqlite3_bind_int(deleteStatement, 1, Int32(productData.id ?? 0))
                
                // Execute the DELETE statement
                if sqlite3_step(deleteStatement) == SQLITE_DONE {
                    // Deletion successful
                    print("Successfully deleted data")
                    sqlite3_finalize(deleteStatement) // Finalize the statement
                    sqlite3_close(db) // Close the database connection
                    return true
                } else {
                    // Deletion failed
                    print("Error deleting data: ", sqlite3_errmsg(db))
                }
            } else {
                // Error preparing the statement
                print("Error preparing DELETE statement")
            }
            
            // Finalize the statement and close the database connection in case of errors
            sqlite3_finalize(deleteStatement)
            sqlite3_close(db)
        } else {
            // Error opening the database
            print("Error opening database")
        }
        
        return false
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
                    sqlite3_bind_text(insertStatement, 4, quanityStr.utf8String, -1, nil)
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
    

    func updateRecordInDatabase(productData: MyData) {
        let updateQuery = "UPDATE data SET product = ?, code = ?, price = ?, quantity = ?, date = ?, avatar = ? WHERE id = ?;"
        
        if let db = openDatabase() {
            var updateStatement: OpaquePointer?
            if sqlite3_prepare_v2(db, updateQuery, -1, &updateStatement, nil) == SQLITE_OK {
                // Convert fields to NSString before binding
                let productStr = productData.product! as NSString
                let codeStr = productData.code! as NSString
                let priceStr = productData.price! as NSString
                let quantityStr = String(productData.quanity ?? 0) as NSString
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let dateStr = dateFormatter.string(from: productData.date ?? Date()) as NSString
                
                let avatarStr = productData.avatar! as NSString
                
                // Bind parameters
                sqlite3_bind_text(updateStatement, 1, productStr.utf8String, -1, nil)
                sqlite3_bind_text(updateStatement, 2, codeStr.utf8String, -1, nil)
                sqlite3_bind_text(updateStatement, 3, priceStr.utf8String, -1, nil)
                sqlite3_bind_text(updateStatement, 4, quantityStr.utf8String, -1, nil)
                sqlite3_bind_text(updateStatement, 5, dateStr.utf8String, -1, nil)
                sqlite3_bind_text(updateStatement, 6, avatarStr.utf8String, -1, nil)
                sqlite3_bind_int(updateStatement, 7, Int32(productData.id ?? 0))
                
                // Execute the update query
                if sqlite3_step(updateStatement) == SQLITE_DONE {
                    print("Update successful")
                    let rowID = sqlite3_last_insert_rowid(db)
                    print("Successfully updated row \(rowID)")
                    // Update your data source if needed
                } else {
                    print("Update failed")
                }
            } else {
                print("Error preparing update statement")
            }
            sqlite3_finalize(updateStatement)
            sqlite3_close(db)
        } else {
            print("Unable to open database")
        }
    }

    
    func openDatabase() -> OpaquePointer? {
        var db: OpaquePointer? = nil
        if sqlite3_open(databasePath, &db) == SQLITE_OK {
            print("Successfully opened database at \(databasePath)")
            return db
        } else {
            print("Unable to open database")
            return nil
        }
    }
    
}
