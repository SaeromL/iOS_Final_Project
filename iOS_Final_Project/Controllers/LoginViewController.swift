//
//  LoginViewController.swift
//  iOS_Final_Project
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var tfUsername: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var lbError: UILabel!
    @IBOutlet weak var btnLogin: UIButton!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func unwindToLoginController(segue : UIStoryboardSegue)
    {
        
    }
    
    // Check the fields and validate that the data is correct.
    // If everything is correct, this method retunrs nil.
    // Otherwise, it returns the error message
    func validateFields() -> String? {
        
        // Check that all fields are filled in
        if tfUsername.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || tfPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please enter your username or password."
        }
        return nil

    }


    @IBAction func loginTapped(_ sender: Any) {
        
        // Validate text fields
        let error = validateFields()
        
        if error != nil {
            
            // There's something wrong withh the fields, show error message
            self.showError(error!)
        }
        else {
            // Create clean versions of the text field
            let username = tfUsername.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = tfPassword.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Signing in the user
            Auth.auth().signIn(withEmail: username, password: password) {
                (result, error) in
                
                if error != nil {
                    // Can't sign in
                    self.lbError.text = "Either username or password is incorrect."
                    self.lbError.alpha = 1
                }
                else {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let mainViewController = storyboard.instantiateViewController(withIdentifier: "mainViewController")
                    
                    self.view.window?.rootViewController = mainViewController
                    self.view.window?.makeKeyAndVisible()
                }
            }
        }
        
    }
    
    func showError(_ message: String) {
        
        lbError.text = message
        lbError.alpha = 1
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
