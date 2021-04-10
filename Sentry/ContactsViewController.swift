//
//  ContactsViewController.swift
//  Sentry
//
//  Created by Gerdin Ventura on 4/10/21.
//

import UIKit
import Parse
import AlamofireImage

class ContactsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    
    var contacts = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        loadContacts()
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadContacts()
        self.tableView.reloadData()
    }
    
    func loadContacts() {
        let query = PFQuery(className:"Contacts")
        query.order(byAscending: "fullname")
                
        query.findObjectsInBackground { (contacts, error) in
            if contacts != nil {
                self.contacts = contacts!
                self.tableView.reloadData()
//                self.myRefreshControl.endRefreshing()
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell") as! ContactCell
        let contact = contacts[indexPath.row]
        
//      Get post image
        let imageFile = contact["image"] as! PFFileObject
        let imageFileUrl = imageFile.url!
        let imageUrl = URL(string: imageFileUrl)
        
//      Update screen elements
        cell.nameLabel.text = contact["fullname"] as? String
        cell.emailLabel.text = contact["email"] as? String
        cell.relationshipLabel.text = contact["relationship"] as? String
        cell.phoneNumberLabel.text = contact["phonenumber"] as? String
        cell.contactImage.af.setImage(withURL: imageUrl!)
        
//      Makes profile picture round
        cell.contactImage.layer.cornerRadius = cell.contactImage.frame.size.width / 2
        cell.contactImage.clipsToBounds = true
        
         
        cell.contentView.backgroundColor = UIColor.blue
        
        
        
        return cell
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
