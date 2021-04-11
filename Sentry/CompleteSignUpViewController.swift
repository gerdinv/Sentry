//
//  CompleteSignUpViewController.swift
//  Sentry
//
//  Created by Gerdin Ventura on 4/10/21.
//

import UIKit
import Parse

class CompleteSignUpViewController: UIViewController, TYHeightPickerDelegate {
    
    func selectedHeight(height: CGFloat, unit: HeightUnit) {
        self.height = Int(height)
        print(height, unit)
    }

    var heighPicker: TYHeightPicker!
    var height = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTYHeightPicker()
    }
    
    func setupTYHeightPicker() {
        heighPicker = TYHeightPicker()
        heighPicker.translatesAutoresizingMaskIntoConstraints = false
        heighPicker.delegate = self
        self.view.addSubview(heighPicker)
        
        heighPicker.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        heighPicker.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        heighPicker.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        heighPicker.heightAnchor.constraint(equalToConstant: 145).isActive = true
    }
    
    @IBAction func onContinue(_ sender: Any) {
        let user = PFUser.current()
        user!["height"] = self.height
        user!.saveEventually()
        self.performSegue(withIdentifier: "passcodeScreenFromHeight", sender: nil)
        print("Height updated!")
    }
}
