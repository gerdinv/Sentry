//
//  CancelCallViewController.swift
//  Sentry
//
//  Created by Gerdin Ventura on 4/10/21.
//

import UIKit
import Parse
import Alamofire

class CancelCallViewController: UIViewController {

    @IBOutlet weak var triesCounterLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var addressText = String()
    var lati = String()
    var long = String()
    var coordinateText = String()
    
    
    var triesCounter = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        print(addressText)
    }
    
    @IBAction func onCancelCall(_ sender: Any) {
        let user = PFUser.current()!
        let passcode = "\(user["passcode"]!)"
        
        if triesCounter == 1 && passcode != passwordTextField.text {
            triesCounter = 3
            sendAlertRequest()
            //show alert
            let alert = UIAlertController(title: "Help Request Sent!", message: "Everyone on your emergency contact list as well as the authorities have been notified with your details. Help is on the way!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "dismiss", style: .default, handler: changeScreen))
            self.present(alert, animated: true)
            print("help is on the way")
        }
        
        print(passcode)
        print(passwordTextField.text!)
        
        if passcode == passwordTextField.text {
            triesCounter = 3
            self.performSegue(withIdentifier: "backToHomeFromCancel", sender: nil)
        } else {
            triesCounter -= 1
        }

        triesCounterLabel.text = "\(triesCounter)"
    }
    
    func sendAlertRequest() {
        let user = PFUser.current()!
        let query = PFQuery(className:"Contacts")
        query.includeKey("owner")
        query.whereKey("owner", equalTo: PFUser.current()!)
        query.order(byAscending: "fullname")
                
        query.findObjectsInBackground { (contacts: [PFObject]?, error) in
            if contacts != nil {
                for contact in contacts! {
                    let contactNumber = "240-370-6534" //Replace with contact["phonenumber"]
                    let contactEmail = "agprxme@gmail.com" //Replace with contact["email"]
                    let contactName = contact["fullname"] as! String
                    let userFullname = user["fullname"] as! String
                        
                    self.sendAlert(username: user.username!, contactNumber: contactNumber, contactEmail: contactEmail, receiverName: contactName, senderName: userFullname)
                        sleep(5)
                    }
            }
        }
    }

    func sendAlert(username: String, contactNumber: String, contactEmail: String, receiverName: String, senderName: String) {
        let parameters: [String: Any] = [
            "eventId" : "Danger",
            "recipientId" : username,
            "profile": [
                "phone_number" : contactNumber,
                "email": contactEmail
            ],
            "data": [
                "receiverName": receiverName,
                "senderName": senderName,
                "event_location": addressText,
                "coordinates": coordinateText
            ]
        ]
        
        AF.request("http://192.168.0.23:3000/sendText", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
            }
    }
    
    
    func changeScreen(alert: UIAlertAction!) {
        self.performSegue(withIdentifier: "backToHomeFromCancel", sender: nil)
    }
}
