//
//  ReportListingViewController.swift
//  iOS_Final_Project
//


import UIKit

class ReportListingViewController: UIViewController {

    @IBOutlet var btnProductQtd: UIButton!
    
    @IBOutlet var btnProductPrice: UIButton!
    
    @IBOutlet var btnProductAdded: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        
        // Adicionar um campo de texto para a entrada do número
        alert.addTextField { textField in
            textField.placeholder = "Enter a value"
            textField.keyboardType = .numberPad
        }
        
        // Adicione as ações de filtro
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
        guard let number = Int(value) else {
            let alert = UIAlertController(title: "Invalid Input", message: "Please enter a valid number.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        
        print("Report generated with filter: \(filter) and value: \(number) for report type: \(reportType)")
        
        if let reportDetailsViewController = storyboard?.instantiateViewController(withIdentifier: "DisplayReportViewController") as? DisplayReportViewController {
            reportDetailsViewController.filter = filter
            reportDetailsViewController.value = number
            reportDetailsViewController.reportType = reportType
            navigationController?.pushViewController(reportDetailsViewController, animated: true)
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
