//
//  SearchViewController.swift
//  iOS_Final_Project
//


import UIKit
import SQLite3

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tfProductName: UITextField!
    @IBOutlet weak var tfPrice: UITextField!
    @IBOutlet weak var tfCode: UITextField!
    @IBOutlet weak var tfQuantity: UITextField!
    @IBOutlet weak var dpDate: UIDatePicker!
    @IBOutlet weak var tableView: UITableView!
    
    var searchResults: [MyData] = []
    var db: OpaquePointer?
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // Register the cell class
        tableView.register(EasySiteCell.self, forCellReuseIdentifier: "cell")
        // Do any additional setup after loading the view.
        mainDelegate.readDataFromDatabase()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell : EasySiteCell = tableView.dequeueReusableCell(withIdentifier: "easySiteCell", for: indexPath) as? EasySiteCell ?? EasySiteCell(style: .default, reuseIdentifier: "easySiteCell")
        let data = searchResults[indexPath.row]
        
        // Set the title and data for each label
        if let product = data.product {
            tableCell.primaryLabel.text = "Product Name: \(product)"
        } else {
            tableCell.primaryLabel.text = "Product Name: N/A"
        }
        
        if let code = data.code {
            tableCell.secondaryLabel.text = "Product Code: \(code)"
        } else {
            tableCell.secondaryLabel.text = "Product Code: N/A"
        }
        
        if let price = data.price {
            tableCell.thirdLabel.text = "Price: \(price)"
        } else {
            tableCell.thirdLabel.text = "Price: N/A"
        }
        
        if let quantity = data.quanity {
            tableCell.fourLabel.text = "Quantity: \(quantity)"
        } else {
            tableCell.fourLabel.text = "Quantity: N/A"
        }

        if let date = data.date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            tableCell.fifthLabel.text = "Date: \(dateFormatter.string(from: date))"
        } else {
            tableCell.fifthLabel.text = "Date: N/A"
        }
        
        if let avatarName = data.avatar {
            tableCell.profileImg.image = UIImage(named: avatarName)
        } else {
            // Handle the case where avatar is nil or empty
            tableCell.profileImg.image = nil
        }
        
        return tableCell
    }

    @IBAction func searchButtonTapped(_ sender: Any) {
    
        //if let productName = tfProductName?.text { print(productName) }
        searchForProducts()
        
        // Reload the table view with search results
        tableView.reloadData()
    }
    
    func searchForProducts() {
        
        guard let db = (UIApplication.shared.delegate as? AppDelegate)?.db else {
            print("Error accessing database")
            return
        }
        
        
        let name = tfProductName.text ?? ""
        let price = tfPrice.text ?? ""
        let code = tfCode.text ?? ""
        let quantity = tfQuantity.text ?? ""
        let date = dpDate.date

        // Construct your SQL query based on the entered values
        var queryString = "SELECT * FROM data WHERE 1=1"

        // Append conditions to the query based on the entered values
        if !name.isEmpty {
            queryString += " AND product LIKE '%\(name)%'"
            print(queryString)
        }
        if !price.isEmpty {
            queryString += " AND price = '\(price)'"
            print(queryString)
        }
        if !code.isEmpty {
            queryString += " AND code LIKE '%\(code)%'"
            print(queryString)
        }
        if !quantity.isEmpty {
            queryString += " AND quantity = '\(quantity)'"
            print(queryString)
        }
            
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        queryString += " AND date = '\(dateString)'"

        // Execute the constructed SQL query on the SQLite database
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, queryString, -1, &statement, nil) == SQLITE_OK {
            print(db)
            searchResults.removeAll()

            while sqlite3_step(statement) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(statement, 0))
                let product = String(cString: sqlite3_column_text(statement, 1))
                let code = String(cString: sqlite3_column_text(statement, 2))
                let price = String(cString: sqlite3_column_text(statement, 3))
                let quantity = Int(sqlite3_column_int(statement, 4))
                let dateString = String(cString: sqlite3_column_text(statement, 5))
                let dateFormatter = DateFormatter()
                let date = dateFormatter.date(from: dateString) ?? Date()
                let avatar = String(cString: sqlite3_column_text(statement, 6))

                let data = MyData() // Initialize MyData object
                data.id = id
                data.product = product
                data.code = code
                data.price = price
                data.quanity = quantity
                data.date = date
                data.avatar = avatar

                searchResults.append(data)
                print(data)
                }
            } else {
                print("Error preparing query: \(String(cString: sqlite3_errmsg(db)))")
            }

            // Finalize the statement and close it
            sqlite3_finalize(statement)

            // Reload table view to display search results
            tableView.reloadData()
        }
    
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


