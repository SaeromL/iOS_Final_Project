//
//  RegisterViewController.swift
//  iOS_Final_Project
//
//  Created by Anosha Bari on 2024-04-10.
//

import UIKit

class RegisterViewController: UIViewController {
    
    
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Additional setup if needed
    }
    
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        // Validate input fields
        guard let name = tfName.text, !name.isEmpty else {
            showAlert(message: "Please enter your name.")
            return
        }
        
        guard let email = tfEmail.text, !email.isEmpty else {
            showAlert(message: "Please enter your email.")
            return
        }
        
        guard let password = tfPassword.text, !password.isEmpty else {
            showAlert(message: "Please enter your password.")
            return
        }
        
        // Save user's info (for demo purposes, you can use UserDefaults)
        UserDefaults.standard.set(name, forKey: "userName")
        UserDefaults.standard.set(email, forKey: "userEmail")
        UserDefaults.standard.set(password, forKey: "userPassword")
        
        // Show success message or perform segue to login view controller
        showAlert(message: "Registration successful!") { _ in
            self.dismiss(animated: true, completion: nil) // Dismiss the registration view
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        // Dismiss the registration view controller
        dismiss(animated: true, completion: nil)
    }
    
    func showAlert(message: String, completion: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: completion)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
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
