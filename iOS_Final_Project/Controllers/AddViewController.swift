//
//  AddViewController.swift
//  iOS_Final_Project
//


import UIKit

class AddViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var productListBtn: UIButton!
   
    @IBOutlet var slVolume : UISlider!
    @IBOutlet var lbVolume : UILabel!
    
    @IBOutlet var tfName: UITextField!
    @IBOutlet var tfCode: UITextField!
    @IBOutlet var tfPrice: UITextField!
    
    @IBOutlet var datePicker: UIDatePicker!
    
    @IBOutlet var submitButton: UIButton!
    var selectedAvatar: String = ""
    
    // Action for avatar button 1
      @IBAction func profile1BtnTapped(_ sender: UIButton) {
          selectedAvatar = "batman.jpeg"
          print(selectedAvatar)
      }
      
      // Action for avatar button 2
      @IBAction func profile2BtnTapped(_ sender: UIButton) {
          selectedAvatar = "superman.png"
          print(selectedAvatar)
      }
      
      // Action for avatar button 3
      @IBAction func profile3BtnTapped(_ sender: UIButton) {
          selectedAvatar = "flash.jpeg"
          print(selectedAvatar)
      }

  
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateLabel()
        // Do any additional setup after loading the view.
        let defaults = UserDefaults.standard
        if  let product = defaults.object(forKey: "lastProduct") as? String {
            tfName.text = product
        }
        if  let code = defaults.object(forKey: "lastCode") as? String {
            tfCode.text = code
        }
        if  let price = defaults.object(forKey: "lastPrice") as? String {
            tfPrice.text = price
        }
        if let lastDateStr = defaults.string(forKey: "lastDate") {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if let lastDate = dateFormatter.date(from: lastDateStr) {
                datePicker.maximumDate = lastDate
            }
        }

    }


    @IBAction func addProduct(sender: UIButton) {
                let productData = MyData()
              
                // Convert qty from the slider's value to an integer
                let quanity = Int(slVolume.value)
              
                // Convert Date of Birth from DatePicker to Date
                let datePicker = datePicker.date
                 
        productData.initWithData(theRow: 0, theProduct: tfName.text!, theCode: tfCode.text!,thePrice: tfPrice.text!,theQuanity: quanity , theDate: datePicker, theAvatar: selectedAvatar)
                
                let mainDelegate = UIApplication.shared.delegate as! AppDelegate
                let returnCode: Bool = mainDelegate.insertIntoDatabase(productData: productData)
                print(productData.avatar)
                var returnMsg = "Product added"
                
                if !returnCode {
                    returnMsg = "Product add failed"
                }
                
                let alertController = UIAlertController(title: "SQL Add", message: returnMsg, preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "OK", style: .cancel)
                alertController.addAction(cancelAction)
                present(alertController, animated: true)
            }

    
   
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch : UITouch = touches.first!
        let touchPoint : CGPoint = touch.location(in: self.view!)
        
        let tableFrame : CGRect = productListBtn.frame
        
        
        if tableFrame.contains(touchPoint)
        {
            rememberEnteredData()
            performSegue(withIdentifier: "HomeSegueToTable", sender: self)
        }
       
    }
    func rememberEnteredData(){
        let defaults = UserDefaults.standard
        defaults.set(tfName.text, forKey:"lastProduct")
        defaults.set(tfCode.text, forKey:"lastCode")
        defaults.set(tfPrice.text, forKey:"lastPrice")
        defaults.set(slVolume.value, forKey: "lastQty")
    
      
    }
    
    @IBAction func sliderValueChanged(sender : UISlider)
    {
        updateLabel()
    }
    func updateLabel(){
        let vol = slVolume.value
            let roundedVol = Int(vol)
            lbVolume.text = "\(roundedVol)"
    }

   

}
