//
//  EditViewController.swift
//  iOS_Final_Project
//
//  Created by Saerom Lee on 2024-04-14.
//

import UIKit

class EditViewController: UIViewController {
    
    @IBOutlet var tfName: UITextField!
    @IBOutlet var tfCode: UITextField!
    @IBOutlet var tfPrice: UITextField!
    @IBOutlet var slVolume: UISlider!
    @IBOutlet var lbVolume: UILabel!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var profile1Btn: UIButton!
    @IBOutlet var profile2Btn: UIButton!
    @IBOutlet var profile3Btn: UIButton!
    @IBOutlet var btnConfirm: UIButton!
    
    var selectedAvatar: String = ""
    var product: MyData?


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateLabel()
        loadProductData()
    }
    
    // Function to load product data into UI elements
    func loadProductData() {
        
        guard let product = product else {
            return
        }
        
        tfName.text = product.product
        tfCode.text = product.code
        tfPrice.text = product.price
        slVolume.value = Float(Int(product.quanity ?? 0)) // Unwrap and provide a default value if nil
        if let date = product.date {
            datePicker.date = date
        }
        
        // Set selected avatar
        selectedAvatar = product.avatar ?? ""
        updateButtonAppearance()
    }
    
    
    // Function to update the appearance of avatar buttons based on the selected avatar
    func updateButtonAppearance() {
        // Reset appearance for all buttons
        profile1Btn.layer.borderColor = UIColor.clear.cgColor
        profile2Btn.layer.borderColor = UIColor.clear.cgColor
        profile3Btn.layer.borderColor = UIColor.clear.cgColor
        
        // Set appearance for selected button
        switch selectedAvatar {
        case "batman.jpeg":
            profile1Btn.layer.borderColor = UIColor.blue.cgColor
            profile1Btn.layer.borderWidth = 2
        case "superman.png":
            profile2Btn.layer.borderColor = UIColor.blue.cgColor
            profile2Btn.layer.borderWidth = 2
        case "flash.jpeg":
            profile3Btn.layer.borderColor = UIColor.blue.cgColor
            profile3Btn.layer.borderWidth = 2
        default:
            break
        }
    }
    
    // Action for avatar button 1
    @IBAction func profile1BtnTapped(_ sender: UIButton) {
        selectedAvatar = "batman.jpeg"
        updateButtonAppearance()
    }
    
    // Action for avatar button 2
    @IBAction func profile2BtnTapped(_ sender: UIButton) {
        selectedAvatar = "superman.png"
        updateButtonAppearance()
    }
    
    // Action for avatar button 3
    @IBAction func profile3BtnTapped(_ sender: UIButton) {
        selectedAvatar = "flash.jpeg"
        updateButtonAppearance()
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        updateLabel()
    }
    
    func updateLabel() {
        let vol = slVolume.value
        let roundedVol = Int(vol)
        lbVolume.text = "\(roundedVol)"
    }
    

    @IBAction func saveChanges(_ sender: UIButton) {
        
        guard let updatedProduct = product else {
            print("Error: Product is nil")
            return
        }
        
        // Update the product data with the edited values
        updatedProduct.product = tfName.text ?? ""
        updatedProduct.code = tfCode.text ?? ""
        updatedProduct.price = tfPrice.text ?? ""
        updatedProduct.quanity = Int(slVolume.value)
        updatedProduct.date = datePicker.date
        updatedProduct.avatar = selectedAvatar ?? ""
        
        // Format the date for display purposes
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: datePicker.date)
        
        // Print the updated product information
        print("Updated product: \(updatedProduct.product ?? "") | Updated code: \(updatedProduct.code ?? "") | Updated price: \(updatedProduct.price ?? "") | Updated quantity: \(updatedProduct.quanity ?? 0) | Selected Date: \(dateString) | Selected avatar: \(updatedProduct.avatar ?? "")")
        
        // Call the update function in AppDelegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.updateRecordInDatabase(productData: updatedProduct)
        
        // Show alert for successful update
        let alert = UIAlertController(title: "Success", message: "Record updated successfully", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            // Dismiss the edit view controller
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(okAction)
        present(alert, animated: true)
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
