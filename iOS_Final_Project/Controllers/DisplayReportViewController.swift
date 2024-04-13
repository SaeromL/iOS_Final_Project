//
//  DisplayReportViewController.swift
//  iOS_Final_Project
//


import UIKit

class DisplayReportViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let filter = filter, let value = value, let reportType = reportType {
            // Here you will fetch and display the report details using the filter and the value
            print("Displaying report details with filter: \(filter), value: \(value), and report type: \(reportType)")
            // Fetch and display report details based on filter and value
        }
    }
    
    var filter: String?
        var value: Int? // Add this line for the numeric value
        var reportType: String?
        
       
            
        
        
       
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
