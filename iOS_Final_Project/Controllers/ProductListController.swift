//
//  ProductListController.swift
//  iOS_Final_Project
//


import UIKit

class ProductListController: UIViewController, UITableViewDataSource, UITableViewDelegate {

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
        return mainDelegate.productData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let tableCell: EasySiteCell = tableView.dequeueReusableCell(withIdentifier: "easySiteCell")  as? EasySiteCell ?? EasySiteCell(style: .default, reuseIdentifier: "easySiteCell")
                                                                        
        let rowNum = indexPath.row
        tableCell.primaryLabel.text = mainDelegate.productData[rowNum].product!
        tableCell.secondaryLabel.text = mainDelegate.productData[rowNum].code
        tableCell.thirdLabel.text = mainDelegate.productData[rowNum].price
        
       
        if let quanity = mainDelegate.productData[rowNum].quanity {
            tableCell.fourLabel.text = String(quanity)
         } else {
             tableCell.fourLabel.text = ""
         }
        
        if let dob = mainDelegate.productData[rowNum].date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            tableCell.fifthLabel.text = dateFormatter.string(from: dob)
        } else {
            tableCell.fifthLabel.text = ""
        }

        
        let imgName = UIImage(named: mainDelegate.productData[rowNum].avatar!)
        
        tableCell.profileImg.image = imgName
        tableCell.accessoryType = .disclosureIndicator
        return tableCell
    
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let more = UITableViewRowAction(style: .normal, title: "More", handler:
                                            {
            action, index in print("More button tapped")
        })
        more.backgroundColor = .lightGray
        let favourite = UITableViewRowAction(style: .normal, title: "Favourite", handler: {
            action, index in print("Favourite button tapped")
        })
        favourite.backgroundColor = .orange
        
        let share = UITableViewRowAction(style: .normal, title: "Share", handler: {
            action, index in print("Share button tapped")
        })
        share.backgroundColor = .blue
        
        return [more, favourite , share]
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let modifyAction = UIContextualAction(style: .destructive, title: "Delete", handler: { [weak self] _, _, completionHandler in
            guard let self = self else { return }
            
            let dataToDelete = self.mainDelegate.productData[indexPath.row]
            
            // Call the delete method from AppDelegate
            if self.mainDelegate.deleteDataFromSQLite(productData: dataToDelete) {
                // If deletion is successful, remove the item from the data source
                self.mainDelegate.productData.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            } else {
                // Handle deletion failure
                // You can show an alert or perform any other action here
                print("Failed to delete data")
            }
            
            // Call the completion handler
            completionHandler(true)
        })
        modifyAction.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [modifyAction])
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rowNum = indexPath.row
        
        let alertcontroller = UIAlertController(title: mainDelegate.productData[rowNum].product, message: mainDelegate.productData[rowNum].code ,preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Ok", style: .cancel)
        alertcontroller.addAction(cancelAction)
        present(alertcontroller, animated: true)
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

