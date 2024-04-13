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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func allProductcsReport(_ sender: Any) {
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
       
    private func showFilterOptions(forReportType reportType: String) {
        let alert = UIAlertController(title: "Report Filter", message: "Choose the filter and enter a value", preferredStyle: .alert)

        alert.addTextField { textField in
            if reportType == "added" {
                textField.placeholder = "Enter date (yyyy-MM-dd)"
            } else {
                textField.placeholder = "Enter a value"
                textField.keyboardType = .numberPad
            }
        }
        
        alert.addAction(UIAlertAction(title: "Equal", style: .default, handler: { _ in
            if let value = alert.textFields?.first?.text, !value.isEmpty {
                self.generateReport(filter: "equal", value: value, reportType: reportType)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Greater than", style: .default, handler: { _ in
            if let value = alert.textFields?.first?.text, !value.isEmpty {
                self.generateReport(filter: "greater", value: value, reportType: reportType)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Less than", style: .default, handler: { _ in
            if let value = alert.textFields?.first?.text, !value.isEmpty {
                self.generateReport(filter: "less", value: value, reportType: reportType)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func generateReport(filter: String, value: String, reportType: String) {
        if reportType == "added" {
            guard let dateValue = convertStringToDate(value) else {
                invalidInputAlert(message: "Please enter a valid date in format yyyy-MM-dd.")
                return
        }
            
            navigateToDisplayReportViewController(filter: filter, date: dateValue, reportType: reportType)
        } else {
            // Para 'quantity' e 'price', esperamos um valor numérico
            guard let numberValue = Int(value) else {
                invalidInputAlert(message: "Please enter a valid number.")
                return
            }
            
            navigateToDisplayReportViewController(filter: filter, value: numberValue, reportType: reportType)
        }
    }

    private func invalidInputAlert(message: String) {
        let alert = UIAlertController(title: "Invalid Input", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    private func navigateToDisplayReportViewController(filter: String, value: Int? = nil, date: Date? = nil, reportType: String) {
        if let reportDetailsViewController = storyboard?.instantiateViewController(withIdentifier: "DisplayReportViewController") as? DisplayReportViewController {
            reportDetailsViewController.filter = filter
            reportDetailsViewController.value = value
            reportDetailsViewController.date = date
            reportDetailsViewController.reportType = reportType
            navigationController?.pushViewController(reportDetailsViewController, animated: true)
        }
    }

    private func convertStringToDate(_ dateString: String, dateFormat: String = "yyyy-MM-dd") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.date(from: dateString)
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
