//
//  HomeViewController.swift
//  Sentry
//
//  Created by Gerdin Ventura on 4/10/21.
//

import UIKit
import CoreLocation
import MaterialComponents.MaterialButtons
import Parse
import Alamofire

class HomeViewController: UIViewController, CLLocationManagerDelegate  {

    @IBOutlet weak var sentryButton: UIButton!
    @IBOutlet weak var secondsLabel: UILabel!
    
    var timer = Timer()
    var manager = CLLocationManager()
    var longitude = ""
    var latitude = ""
    var coordinate = ""
    var addressString : String = ""
    var seconds: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = kCLDistanceFilterNone
        manager.startUpdatingLocation()
        
        sentryButton.layer.cornerRadius = sentryButton.frame.width / 2
        sentryButton.layer.masksToBounds = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let user = PFUser.current()!
        seconds = user["timer"] as! Int
        secondsLabel.text = "\(seconds)"
        getAddressFromLatLon(pdblLatitude: self.latitude, withLongitude: self.longitude)
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
                "event_location": addressString,
                "coordinates": coordinate
            ]
        ]
        AF.request("http://192.168.0.23:3000/sendText", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
            }
    }
    
    func runTimer(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(HomeViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    func resetTimer(){
        timer.invalidate()
        let user = PFUser.current()!
        seconds = user["timer"] as! Int
        runTimer()
        secondsLabel.text = "\(seconds)"
    }
    
    func stopTimer(){
        timer.invalidate()
    }
    
    @objc func updateTimer(){
        if seconds > -1 {
            seconds -= 1
        }
        secondsLabel.text = "\(seconds)"
        
       if seconds <= 0 {
            print("call for help")
            stopTimer()
            timer.invalidate()
            sendAlertRequest()
            let alert = UIAlertController(title: "Authorities Notified", message: "A message with your location and information has been sent to your emergency contacts and the authorities", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "dismiss", style: .default, handler: changeScreen))
            self.present(alert, animated: true)
       }
    }
    
    func changeScreen(alert: UIAlertAction!) {
        resetTimer()
        stopTimer()
    }
    
    @IBAction func onSentryButton(_ sender: Any) {
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(normalTap))
        sentryButton.addGestureRecognizer(tapGesture)

        let longGesture: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longTap))
        sentryButton.addGestureRecognizer(longGesture)
    }
    
    @objc func normalTap(_ sender: UIGestureRecognizer){
        print("Normal tap")
    }
    
    @objc func longTap(_ sender: UIGestureRecognizer){
        print("Long tap")
        
        if sender.state == .ended {
            runTimer()
            updateTimer()
        }
        else if sender.state == .began {
            print("UIGestureRecognizerStateBegan.")
        }
    }
    
    override func viewDidLayoutSubviews() {
        let button = MDCButton()
        button.minimumSize = CGSize(width: 64, height: 48)
        button.centerVisibleArea = true
        
        view.addSubview(button)
    }
    
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = Double(self.latitude)!
        center.longitude = Double(self.longitude)!
        
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
                        self.addressString = newAddress
                  }
            })
        }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let first = locations.first else {
            return
        }
        longitude = "\(first.coordinate.longitude)"
        latitude = "\(first.coordinate.latitude)"
        coordinate = "\(latitude),\(longitude)"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        stopTimer()
        if segue.identifier == "cancelCallSegue" {
            let destination = segue.destination as! CancelCallViewController
            destination.addressText = self.addressString
            destination.coordinateText = self.coordinate
            destination.lati = self.latitude
            destination.long = self.longitude
        }
    }
}
