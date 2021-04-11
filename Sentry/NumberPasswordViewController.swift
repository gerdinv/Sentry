//
//  NumberPasswordViewController.swift
//  Sentry
//
//  Created by Gerdin Ventura on 4/10/21.
//

import UIKit
import Parse

class NumberPasswordViewController: UIViewController {

    @IBOutlet weak var passcodeTextField: UITextField!
    @IBOutlet weak var finishButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        finishButton.layer.cornerRadius = 8
        
        let passcode = NSAttributedString(string: "Passcode",
                                                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        passcodeTextField.attributedPlaceholder = passcode
       
    }
    
    @IBAction func onFinish(_ sender: Any) {
        let count = passcodeTextField.text!.count
        if count < 6 {
            let alert = UIAlertController(title: "Invalid input", message: "Please enter a code 6 digits or larger", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "dismiss", style: .default, handler: nil))
            self.present(alert, animated: true)
        } else {
            let user = PFUser.current()
            user!["passcode"] = Int(passcodeTextField.text!)
            user!.saveEventually()
            self.performSegue(withIdentifier: "finishSignUp", sender: nil)
            print("passcode updated!")
        }

        //finishSignUp
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
