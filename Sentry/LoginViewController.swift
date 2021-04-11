//
//  LoginViewController.swift
//  Sentry
//
//  Created by Gerdin Ventura on 4/9/21.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signinButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        signinButton.layer.cornerRadius = 8
        registerButton.layer.cornerRadius = 8
    }
    
    @IBAction func onLogin(_ sender: Any) {
        let email = emailTextField.text
        let password = passwordTextField.text
        
        PFUser.logInWithUsername(inBackground: email!, password: password!) {
          (user, error)  in
          if user != nil {
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
          } else {
            let alert = UIAlertController(title: "Wrong Credentials", message: "Invalid username or password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "dismiss", style: .default, handler: nil))
            self.present(alert, animated: true)
          }
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
