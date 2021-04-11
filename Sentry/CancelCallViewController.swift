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
    
    var triesCounter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onCancelCall(_ sender: Any) {
        let user = PFUser.current()!
        
        
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
