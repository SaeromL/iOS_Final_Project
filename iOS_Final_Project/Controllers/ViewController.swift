//
//  ViewController.swift
//  iOS_Final_Project
//


import UIKit
import FirebaseAuth

class ViewController: UIViewController {
    @IBOutlet var productListBtn: UIButton!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
    }
    @IBAction func unwindToViewController(segue : UIStoryboardSegue)
    {
        
    }
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        // Check if the user is authenticated
        if Auth.auth().currentUser == nil {
            // User is not authenticated, present the login screen
            presentLoginScreen()
        } else {
            // User is authenticated, perform the action
            performSegue(withIdentifier: "addProductSegue", sender: self)
        }
    }
    
    @IBAction func listButtonTapped(_ sender: UIButton) {
        // Check if the user is authenticated
        if Auth.auth().currentUser == nil {
            // User is not authenticated, present the login screen
            presentLoginScreen()
        } else {
            // User is authenticated, perform the action
            performSegue(withIdentifier: "listProductSegue", sender: self)
        }
    }
    
    @IBAction func reportButtonTapped(_ sender: UIButton) {
        // Check if the user is authenticated
        if Auth.auth().currentUser == nil {
            // User is not authenticated, present the login screen
            presentLoginScreen()
        } else {
            // User is authenticated, perform the action
            performSegue(withIdentifier: "reportProductSegue", sender: self)
        }
    }
    
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        // Check if the user is authenticated
        if Auth.auth().currentUser == nil {
            // User is not authenticated, present the login screen
            presentLoginScreen()
        } else {
            // User is authenticated, perform the action
            performSegue(withIdentifier: "searchProductSegue", sender: self)
        }
    }
    
    
    func presentLoginScreen() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        loginViewController.modalPresentationStyle = .fullScreen
        present(loginViewController, animated: true, completion: nil)
    }
    
}

