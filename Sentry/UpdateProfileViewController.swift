//
//  UpdateProfileViewController.swift
//  Sentry
//
//  Created by Gerdin Ventura on 4/10/21.
//

import UIKit
import Parse
import AlamofireImage
import iOSDropDown
import Parse

class UpdateProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var eyeColorLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var hairColorLabel: UILabel!
    
    @IBOutlet weak var fullAddressTextField: UITextField!
    @IBOutlet weak var eyeColorDropDown: DropDown!
    @IBOutlet weak var hairColorDropDown: DropDown!
    @IBOutlet weak var secondsLabel: UILabel!
    @IBOutlet weak var updateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        updateButton.layer.cornerRadius = 8
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.layer.borderColor = UIColor.black.cgColor
        profileImage.layer.borderWidth = 1
        profileImage.clipsToBounds = true
        initalizeEyeColorDD()
        initalizeHairColorDD()
        updateLabelPlaceholders()
        loadUser()
        // Do any additional setup after loading the view.
    }
    
    func updateLabelPlaceholders() {
        
        let address = NSAttributedString(string: "Full Address",
                                                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        fullAddressTextField.attributedPlaceholder = address
        
        
        let eyeColor = NSAttributedString(string: "Eye Color",
                                                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        eyeColorDropDown.attributedPlaceholder = eyeColor
        
        let hairColor = NSAttributedString(string: "Hair Color",
                                                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        hairColorDropDown.attributedPlaceholder = hairColor
    }

    @IBAction func onCameraButton(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    func loadUser() {
        let user = PFUser.current()!
        let fullname = user["fullname"]!
        let eyeColor = user["eyeColor"]
        let height = user["height"]
        let address = user["address"]
        let gender = user["gender"]
        let hairColor = user["hairColor"]
        let timer = user["timer"]
        
        
//      Getting image
        let imageFile = user["profileImage"] as! PFFileObject
        let imageFileUrl = imageFile.url!
        let imageUrl = URL(string: imageFileUrl)
                
        profileImage.af.setImage(withURL: imageUrl!)
        fullnameLabel.text = (fullname as! String)
        eyeColorLabel.text = (eyeColor as! String)
        heightLabel.text = ("\(height!)")
        addressLabel.text = (address as! String)
        genderLabel.text = (gender as! String)
        hairColorLabel.text = (hairColor as! String)
        secondsLabel.text = "\(timer!)"
//        timerSlider.setValue(timer, animated: false)
    }
    
    @IBAction func onSlider(_ sender: UISlider) {
        secondsLabel.text = "\(Int(sender.value))"
    }
    
    @IBAction func onUpdate(_ sender: Any) {
        let user = PFUser.current()!
        let imageData = profileImage.image!.pngData()
        let imageFile = PFFileObject(data: imageData!)
            
        user["profileImage"] = imageFile
        user["timer"] = Int(secondsLabel.text!)
        user["address"] = fullAddressTextField.text
        user["eyeColor"] = eyeColorLabel.text
        user["hairColor"] = hairColorLabel.text
        
        user.saveInBackground { (success, error) in
            if success {
                   let alert = UIAlertController(title: "Updated Profile Successfully!", message: "Your profile has now been updated.", preferredStyle: .alert)
                   alert.addAction(UIAlertAction(title: "dismiss", style: .default, handler: nil))
                
                self.loadUser()
                   self.present(alert, animated: true)
                   
               } else {
                   let alert = UIAlertController(title: "Error updating profile", message: "There was an error updating your profile. Please try again later.", preferredStyle: .alert)
                   alert.addAction(UIAlertAction(title: "dismiss", style: .default, handler: nil))
                   self.present(alert, animated: true)
                   print("ERROR! \(String(describing: error))")
               }
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        
        let size = CGSize(width: 200, height: 200)
        let scaledImage = image.af.imageAspectScaled(toFill: size)
        
        profileImage.image = scaledImage
        dismiss(animated: true, completion: nil)
    }
    
    func initalizeEyeColorDD() {
        eyeColorDropDown.optionArray = ["Amber", "Blue", "Brown", "Dark Brown", "Gray", "Green", "Light Brown", "Hazel"]
         eyeColorDropDown.optionIds = [0,1,2,3,4,5,6,7]
         eyeColorDropDown.selectedRowColor = .darkGray
         eyeColorDropDown.rowBackgroundColor = .black
         eyeColorDropDown.isSearchEnable = false
     }

     func initalizeHairColorDD() {
         hairColorDropDown.optionArray = ["Amber", "Blue", "Brown", "Dark Brown", "Gray", "Green", "Light Brown", "Hazel"]
         hairColorDropDown.optionIds = [0,1,2,3,4,5,6,7]
         hairColorDropDown.selectedRowColor = .darkGray
         hairColorDropDown.rowBackgroundColor = .black
         hairColorDropDown.isSearchEnable = false
     }
    
    
    @IBAction func onLogout(_ sender: Any) {
        PFUser.logOut()
        
        let main = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = main.instantiateViewController(identifier: "loginViewController")
        let delegate = self.view.window?.windowScene?.delegate as! SceneDelegate
        
        delegate.window?.rootViewController = loginViewController
    }

}
