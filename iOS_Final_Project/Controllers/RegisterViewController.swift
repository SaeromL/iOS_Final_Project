//
//  RegisterViewController.swift
//  iOS_Final_Project
//


import UIKit
import FirebaseAuth
import FirebaseCoreInternal
import Firebase


class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        errorPrompt()
    }
    
    func errorPrompt() {
        // Hide the error label
        errorLabel.alpha = 0
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        performSegue(withIdentifier: "RegisterToLoginSegue", sender: self)
        
    }
    
    @IBAction func registerTapped(_ sender: Any) {
        
        // Validate the fields
        let error = validateFields()
        
        if error != nil {
            // if there's something wrong with the fields, an error message will be displayed
            showError(error!)
        }
        else {
            let email = tfEmail.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = tfPassword.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Create the user
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                
                // Check for any errors
                if err != nil {
                    
                    self.showError("Error creating user")
                }
                else {
                    
                    // User was created successfully, email will be stored in database
                    let db = Firestore.firestore()
                    
                    db.collection("users").addDocument(data: ["email":email, "uid": result!.user.uid ]) { (error) in
                        
                        if error != nil {
                            // Show error message
                            self.showError("Error saving user data")
                        }
                        else
                        {
                            // Registration successful so registration screen will be dismissed
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }
    
    func showError(_ message:String) {
        //error message will be visible
        errorLabel.text = message
        errorLabel.alpha = 1
        
        if let errorMessage = validateFields() {
            print("Error Message:")
            print(errorMessage)
            
            // Set up label properties
            errorLabel.numberOfLines = 0
            errorLabel.lineBreakMode = .byWordWrapping
            
            // Assign error message to label
            errorLabel.text = errorMessage
            errorLabel.alpha = 1  // Make errorLabel visible
        }

    }
    
    
    func validateFields() -> String? {
        // Check if email or password fields are empty
        if tfEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            tfPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields."
        }
        
        // Validate password strength
        let cleanedPassword = tfPassword.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if !Utilities.isPasswordValid(cleanedPassword) {
            // Construct a multi-line error message for password criteria
            let line1 = "Password not secure enough. Must contain:"
            let line2 = "- At least one uppercase letter"
            let line3 = "- At least one special character"
            let line4 = "- At least one digit"
            
            // Combine lines into a single multi-line string
            let errorMessage = "\(line1)\n\(line2)\n\(line3)\n\(line4)"
            
            return errorMessage
        }
        
        return nil  // Return nil if all fields are valid
    }
    

    
    //to make the keyboard disappear
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
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
