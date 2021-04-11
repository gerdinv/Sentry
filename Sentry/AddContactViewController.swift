//
//  AddContactViewController.swift
//  Sentry
//
//  Created by Gerdin Ventura on 4/10/21.
//

import UIKit
import Parse
import AlamofireImage
import iOSDropDown



class AddContactViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var contactImage: UIImageView!
    @IBOutlet weak var relationshipTextField: DropDown!
    @IBOutlet weak var addContactButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        initalizeRelationshipDD()
        contactImage.layer.cornerRadius = contactImage.frame.size.width / 2
        contactImage.clipsToBounds = true
        addContactButton.layer.cornerRadius = 8
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onAddContact(_ sender: Any) {
        let contact = PFObject(className: "Contacts")
        let user = PFUser.current()!
        let imageData = contactImage.image!.pngData()
        let imageFile = PFFileObject(data: imageData!)
        
        contact["owner"] = user
        contact["fullname"] = fullNameTextField.text
        contact["email"] = emailTextField.text
        contact["phonenumber"] = phoneNumberTextField.text
        contact["image"] = imageFile
        contact["relationship"] = relationshipTextField.text
        
        contact.saveInBackground() { (success, error) in
            if success {
                self.performSegue(withIdentifier: "backToContacts", sender: nil)
                
                print("Contact saved!")
            } else {
                print("Error saving contact: \(String(describing: error))")
            }
        }
    }
    
    func updateLabelPlaceholders() {
        let fullname = NSAttributedString(string: "Fullname",
                                                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        fullNameTextField.attributedPlaceholder = fullname
        
        let email = NSAttributedString(string: "Email",
                                                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        emailTextField.attributedPlaceholder = email
        
        
        let phone = NSAttributedString(string: "Phone Number",
                                                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        phoneNumberTextField.attributedPlaceholder = phone
        
        let relationship = NSAttributedString(string: "Relationship",
                                                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        relationshipTextField.attributedPlaceholder = relationship
        

    }
    
    func initalizeRelationshipDD() {
        relationshipTextField.optionArray = ["Parent", "Sibling", "Family Member", "Friend", "Other"]
        relationshipTextField.optionIds = [0,1,2,3,4]
        relationshipTextField.selectedRowColor = .darkGray
        relationshipTextField.rowBackgroundColor = .black
        relationshipTextField.isSearchEnable = false
    }
    
    @IBAction func onCamera(_ sender: Any) {
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
        
        contactImage.image = scaledImage
        dismiss(animated: true, completion: nil)
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
