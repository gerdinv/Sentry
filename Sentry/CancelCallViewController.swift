//
//  CancelCallViewController.swift
//  Sentry
//
//  Created by Gerdin Ventura on 4/10/21.
//

import UIKit
import Parse

class CancelCallViewController: UIViewController {

    @IBOutlet weak var triesCounterLabel: UILabel!
   
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    var triesCounter = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onCancelCall(_ sender: Any) {
        let user = PFUser.current()!
        let passcode = user["passcode"] as? String ?? "incorrect"
        
        if triesCounter == 1 && passcode != passwordTextField.text {
            
            triesCounter = 3
            //show alert
            let alert = UIAlertController(title: "Help Request Sent!", message: "Everyone on your emergency contact list as well as the authorities have been notified with your details. Help is on the way!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "dismiss", style: .default, handler: changeScreen))
            self.present(alert, animated: true)
            print("help is on the way")
        }
        
        if passcode == passwordTextField.text {
            triesCounter = 3
            self.performSegue(withIdentifier: "backToHomeFromCancel", sender: nil)

        } else {
            triesCounter -= 1
        }
        
        
        print(passcode)
        triesCounterLabel.text = "\(triesCounter)"
    }
    
    func changeScreen(alert: UIAlertAction!) {
        self.performSegue(withIdentifier: "backToHomeFromCancel", sender: nil)
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
