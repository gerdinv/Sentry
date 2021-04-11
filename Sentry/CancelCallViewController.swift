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
    
    var addressText = String()
    var lati = String()
    var long = String()
    var coordinateText = String()
    
    
    var triesCounter = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        getAddressFromLatLon(pdblLatitude: lati, withLongitude: long)
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
        
        print(addressText)
        print(coordinateText)
        print(passcode)
        triesCounterLabel.text = "\(triesCounter)"
    }
    
    func changeScreen(alert: UIAlertAction!) {
        self.performSegue(withIdentifier: "backToHomeFromCancel", sender: nil)
    }

    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = Double(self.lati)!
        center.longitude = Double(self.long)!
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)

        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil) {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]
                if pm.count >= 0 {
                    let pm = placemarks![0]
                    var newAddress = ""
                    if pm.subLocality != nil {
                        newAddress += pm.subThoroughfare! + " "
                    }
                    if pm.thoroughfare != nil {
                        newAddress += pm.thoroughfare! + ", "
                    }
                    if pm.locality != nil {
                        newAddress += pm.locality! + ", "
                    }
                    if pm.country != nil {
                        newAddress += pm.country! + ", "
                    }
                    if pm.postalCode != nil {
                        newAddress += pm.postalCode! + " "
                    }
                        self.addressText = newAddress
                  }
            })
        }
}
