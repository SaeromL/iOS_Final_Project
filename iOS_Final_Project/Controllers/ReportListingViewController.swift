//
//  ReportListingViewController.swift
//  iOS_Final_Project
//


import UIKit

class ReportListingViewController: UIViewController {
    
    @IBOutlet var btnProductQtd: UIButton!
    @IBOutlet var btnProductPrice: UIButton!
    @IBOutlet var btnProductAdded: UIButton!
    @IBOutlet var btnAllProducts: UIButton!
    
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainDelegate.readDataFromDatabase()
    }
    
    
    @IBAction func allProducts(_ sender: Any) {
        mainDelegate.allProducts()
        openDisplay()
    }
    
    @IBAction func productQtdReport(_ sender: Any) {
        showFilterOptions(forReportType: "quantity")
        
    }
    
    @IBAction func productAddedReport(_ sender: Any) {
        showFilterOptions(forReportType: "added")
        
    }
    
    @IBAction func productPriceReport(_ sender: Any) {
        showFilterOptions(forReportType: "price")
        
    }
    
    func showFilterOptions(forReportType reportType: String) {
        let alert = UIAlertController(title: "Report Filter", message: "Choose the filter and enter a value", preferredStyle: .alert)
        
        alert.addTextField { textField in
            if reportType == "added" {
                textField.placeholder = "Enter date (yyyy-MM-dd)"
            } else {
                textField.placeholder = "Enter a value"
                textField.keyboardType = .numberPad
            }
        }
        
        let equalAction = UIAlertAction(title: "Equal", style: .default) { _ in
            if let value = alert.textFields?.first?.text, !value.isEmpty {
                self.generateReport(filter: "equal", value: value, reportType: reportType)
            }
        }
        
        let greaterAction = UIAlertAction(title: "Greater than", style: .default) { _ in
            if let value = alert.textFields?.first?.text, !value.isEmpty {
                self.generateReport(filter: "greater", value: value, reportType: reportType)
            }
        }
        
        let lessAction = UIAlertAction(title: "Less than", style: .default) { _ in
            if let value = alert.textFields?.first?.text, !value.isEmpty {
                self.generateReport(filter: "less", value: value, reportType: reportType)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(equalAction)
        alert.addAction(greaterAction)
        alert.addAction(lessAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    private func generateReport(filter: String, value: String, reportType: String) {
        
        switch reportType {
        case "added":
            guard let dateValue = convertStringToDate(value) else {
                invalidInputAlert(message: "Please enter a valid date in format yyyy-MM-dd.")
                return
            }
            
            mainDelegate.filteredProductData = mainDelegate.productData.filter { myData in
                guard let productDate = myData.date else { return false }
                return applyDateFilter(filter: filter, date: productDate, filterDate: dateValue)
            }
            
        case "quantity", "price":
            guard let numberValue = Int(value) else {
                invalidInputAlert(message: "Please enter a valid number.")
                return
            }
            
            mainDelegate.filteredProductData = mainDelegate.productData.filter{ myData in
                if reportType == "quantity", let quantity = myData.quanity {
                    return applyNumberFilter(filter: filter, value: quantity, filterValue: numberValue)
                } else if reportType == "price", let price = Double(myData.price ?? "0") {
                    return applyNumberFilter(filter: filter, value: Int(price), filterValue: numberValue)
                } else {
                    return false
                }
            }
            
        default:
            mainDelegate.filteredProductData = mainDelegate.productData
        }
        openDisplay()
    }
    
    private func applyDateFilter(filter: String, date: Date, filterDate: Date) -> Bool {
        switch filter {
        case "equal":
            return Calendar.current.isDate(date, inSameDayAs: filterDate)
        case "greater":
            return date > filterDate
        case "less":
            return date < filterDate
        default:
            return false
        }
    }
    
    private func applyNumberFilter(filter: String, value: Int, filterValue: Int) -> Bool {
        switch filter {
        case "equal":
            return value == filterValue
        case "greater":
            return value > filterValue
        case "less":
            return value < filterValue
        default:
            return false
        }
    }
    
    private func invalidInputAlert(message: String) {
        let alert = UIAlertController(title: "Invalid Input", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func convertStringToDate(_ dateString: String, dateFormat: String = "yyyy-MM-dd") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.date(from: dateString)
    }
    
    func openDisplay(){
        DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "displayReport", sender: self)
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
}
