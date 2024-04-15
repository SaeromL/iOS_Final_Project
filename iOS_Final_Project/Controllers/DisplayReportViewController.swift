//
//  DisplayReportViewController.swift
//  iOS_Final_Project
//


import UIKit

class DisplayReportViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mainDelegate.readDataFromDatabase()
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainDelegate.filteredProductData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let tableCell: EasySiteCell = tableView.dequeueReusableCell(withIdentifier: "easySiteCell")  as? EasySiteCell ?? EasySiteCell(style: .default, reuseIdentifier: "easySiteCell")
                                                                
        let rowNum = indexPath.row
        tableCell.primaryLabel.text = mainDelegate.filteredProductData[rowNum].product!
        tableCell.secondaryLabel.text = mainDelegate.filteredProductData[rowNum].code
        tableCell.thirdLabel.text = mainDelegate.filteredProductData[rowNum].price
        
       
        if let quanity = mainDelegate.filteredProductData[rowNum].quanity {
            tableCell.fourLabel.text = String(quanity)
         } else {
             tableCell.fourLabel.text = ""
         }
        
        if let dob = mainDelegate.filteredProductData[rowNum].date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            tableCell.fifthLabel.text = dateFormatter.string(from: dob)
        } else {
            tableCell.fifthLabel.text = ""
        }

        
        let imgName = UIImage(named: mainDelegate.filteredProductData[rowNum].avatar!)
        
        tableCell.profileImg.image = imgName
        tableCell.accessoryType = .disclosureIndicator
        return tableCell
    
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
