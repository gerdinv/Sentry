//
//  SignUpViewController.swift
//  Sentry
//
//  Created by Gerdin Ventura on 4/9/21.
//

import UIKit
import AlamofireImage
import iOSDropDown
import Parse

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, TYHeightPickerDelegate {
    func selectedHeight(height: CGFloat, unit: HeightUnit) {
        print(height, unit)
    }

    @IBOutlet weak var eyeColorDropDown: DropDown!
    @IBOutlet weak var hairColorDrowDown: DropDown!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var fullnameTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    
    var gender = ""
    
    var heighPicker: TYHeightPicker!

    override func viewDidLoad() {
        super.viewDidLoad()
        initalizeEyeColorDD()
        initalizeHairColorDD()
        hideKeyboardWhenTappedAround()
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.clipsToBounds = true
        signUpButton.layer.cornerRadius = 8
        updateLabelPlaceholders()
        navigationController?.navigationBar.barTintColor = UIColor.white
    
    }
    
    func updateLabelPlaceholders() {
        let fullname = NSAttributedString(string: "Fullname",
                                                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        fullnameTextField.attributedPlaceholder = fullname
        
        let email = NSAttributedString(string: "Email",
                                                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        emailTextField.attributedPlaceholder = email
        
        let password = NSAttributedString(string: "Password",
                                                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        passwordTextField.attributedPlaceholder = password
        
        let fulladdress = NSAttributedString(string: "Full Address",
                                                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        addressTextField.attributedPlaceholder = fulladdress
        
        let eyeColor = NSAttributedString(string: "Eye Color",
                                                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        eyeColorDropDown.attributedPlaceholder = eyeColor
        
        let hairColor = NSAttributedString(string: "Hair Color",
                                                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        hairColorDrowDown.attributedPlaceholder = hairColor
    }
 
    
    
    
    @IBAction func onSignUp(_ sender: Any) {
        let user = PFUser()
        let imageData = profileImage.image?.pngData()
        let imageFile = PFFileObject(data: imageData!)
        
        user.email = emailTextField.text!
        user.password = passwordTextField.text!
        user.username = fullnameTextField.text!
        user["fullname"] = fullnameTextField.text!
        user["address"] = addressTextField.text!
        user["gender"] = gender
        user["eyeColor"] = eyeColorDropDown.text!
        user["hairColor"] = hairColorDrowDown.text!
        user["profileImage"] = imageFile
        user["height"] = 50
        user["passcode"] = 000000
        user["timer"] = 20
        
        user.signUpInBackground {
            (succeeded: Bool, error: Error?) -> Void in
            if let error = error {
              let errorString = error.localizedDescription
                print(errorString)
              // Show the errorString somewhere and let the user try again.
            } else {
                self.performSegue(withIdentifier: "signUpToHeightSegue", sender: nil)
              print("user saved")
            }
          }
        
    }
    
    @IBAction func onGenderControl(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            gender = "Male"
        } else if sender.selectedSegmentIndex == 1{
            gender = "Female"
        } else {
            gender = "Other"
        }
    }

    func initalizeEyeColorDD() {
        eyeColorDropDown.optionArray = ["Amber", "Blue", "Brown", "Dark Brown", "Gray", "Green", "Light Brown", "Hazel"]
        eyeColorDropDown.optionIds = [0,1,2,3,4,5,6,7]
        eyeColorDropDown.selectedRowColor = .darkGray
        eyeColorDropDown.rowBackgroundColor = .black
        eyeColorDropDown.isSearchEnable = false
    }
    
    func initalizeHairColorDD() {
        hairColorDrowDown.optionArray = ["Amber", "Blue", "Brown", "Dark Brown", "Gray", "Green", "Light Brown", "Hazel"]
        hairColorDrowDown.optionIds = [0,1,2,3,4,5,6,7]
        hairColorDrowDown.selectedRowColor = .darkGray
        hairColorDrowDown.rowBackgroundColor = .black
        hairColorDrowDown.isSearchEnable = false
    }
    
    @IBAction func onCameraButton(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        
        let size = CGSize(width: 200, height: 200)
        let scaledImage = image.af.imageAspectScaled(toFill: size)
        
        profileImage.image = scaledImage
        dismiss(animated: true, completion: nil)
    }
}
