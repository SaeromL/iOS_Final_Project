//
//  DisplayReportViewController.swift
//  iOS_Final_Project
//


import UIKit

class DisplayReportViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var filter: String?
    var value: Int?
    var date: Date?
    var reportType: String?
    
    var filteredProducts: [MyData] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        fetchAndFilterData()
    }
    
    func fetchAndFilterData() {
        if let reportType = reportType {
            switch reportType {
            case "quantity":
                if let filterValue = value {
                    filteredProducts = mainDelegate.productData.filter { myData in
                        switch filter {
                        case "equal": return myData.quanity == filterValue
                        case "greater": return myData.quanity ?? 0 > filterValue
                        case "less": return myData.quanity ?? 0 < filterValue
                        default: return false
                        }
                    }
                }
            case "added":
                if let dateValue = date {
                    filteredProducts = mainDelegate.productData.filter { myData in
                        guard let productDate = myData.date else { return false }
                        switch filter {
                        case "equal": return Calendar.current.isDate(productDate, inSameDayAs: dateValue)
                        case "greater": return productDate > dateValue
                        case "less": return productDate < dateValue
                        default: return false
                        }
                    }
                }
            case "price":
                if let filterValue = value {
                    filteredProducts = mainDelegate.productData.filter { myData in
                        guard let productPrice = Int(myData.price ?? "") else { return false }
                        switch filter {
                        case "equal": return productPrice == filterValue
                        case "greater": return productPrice > filterValue
                        case "less": return productPrice < filterValue
                        default: return false
                        }
                    }
                }
            default:
                break
            }
        }
        tableView.reloadData()
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredProducts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EasySiteCell", for: indexPath) as! EasySiteCell
        
        let myData = filteredProducts[indexPath.row]
        cell.primaryLabel.text = myData.product
        cell.secondaryLabel.text = myData.code
        cell.thirdLabel.text = myData.price
        cell.fourLabel.text = myData.quanity.map(String.init) ?? ""
        cell.fifthLabel.text = myData.date.map { DateFormatter.localizedString(from: $0, dateStyle: .short, timeStyle: .none) } ?? ""
        cell.profileImg.image = UIImage(named: myData.avatar ?? "")
        
        return cell
    }

       
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
