//
//  ContactsViewController.swift
//  Sentry
//
//  Created by Gerdin Ventura on 4/10/21.
//

import UIKit
import Parse

class ContactsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var contacts = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        loadContacts()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadContacts()
        self.tableView.reloadData()
    }
    
    func loadContacts() {
        let query = PFQuery(className:"Contacts")
//        query.includeKeys(["fullname", "email","phonenumber", "image"])
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
        let cell = UITableViewCell()
         
        cell.contentView.backgroundColor = UIColor.yellow
        cell.textLabel!.text = "row: \(indexPath.row)"
        
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
