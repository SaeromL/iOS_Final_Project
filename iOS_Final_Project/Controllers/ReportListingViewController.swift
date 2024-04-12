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
           let alert = UIAlertController(title: "Report Filter", message: "Choose the filter", preferredStyle: .actionSheet)
           
           // Add filter actions
           let equalAction = UIAlertAction(title: "Equal", style: .default) { _ in
               self.generateReport(filter: "equal", reportType: reportType)
           }
           let greaterAction = UIAlertAction(title: "Greater than", style: .default) { _ in
               self.generateReport(filter: "greater", reportType: reportType)
           }
           let lessAction = UIAlertAction(title: "Less than", style: .default) { _ in
               self.generateReport(filter: "less", reportType: reportType)
           }
           
           // Add cancel action
           let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
           
           alert.addAction(equalAction)
           alert.addAction(greaterAction)
           alert.addAction(lessAction)
           alert.addAction(cancelAction)
           
           // Present the action sheet
           present(alert, animated: true)
       }
       
       private func generateReport(filter: String, reportType: String) {
           print("Report generated with filter: \(filter) for report type: \(reportType)")
           
           // Assuming you have set up your DisplayReportViewController in the storyboard
           if let reportDetailsViewController = storyboard?.instantiateViewController(withIdentifier: "DisplayReportViewController") as? DisplayReportViewController {
               reportDetailsViewController.filter = filter
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
