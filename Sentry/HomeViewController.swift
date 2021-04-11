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


class HomeViewController: UIViewController, CLLocationManagerDelegate  {

    @IBOutlet weak var sentryButton: UIButton!
    
    @IBOutlet weak var secondsLabel: UILabel!
    
    @IBOutlet weak var dangerLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    var manager = CLLocationManager()
    var longitude = ""
    var latitude = ""
    var coordinate = ""
    var addressString : String = ""
    
    var seconds = 15
    var timer = Timer()
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = kCLDistanceFilterNone
        manager.startUpdatingLocation()

    }
    
    func runTimer(){
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(HomeViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer(){
        seconds -= 1
        secondsLabel.text = "\(seconds)"
        
        if seconds == 0 {
            timer.invalidate()
            print("call for help")
            dangerLabel.text = "HELP IS ON THE WAY!!!"
            
        }
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
            
            print("CONTACTS NOTIFIED!!!!")
//            labelOne.text = "EMERGENCY CONTACTS NOTIFIED!!!!"
            
            print("UIGestureRecognizerStateEnded")
            //Do Whatever You want on End of Gesture
        }
        else if sender.state == .began {
            print("UIGestureRecognizerStateBegan.")
            //Do Whatever You want on Began of Gesture
        }
    }
    
    override func viewDidLayoutSubviews() {
        let button = MDCButton()
        button.minimumSize = CGSize(width: 64, height: 48)
        button.centerVisibleArea = true
        
        view.addSubview(button)
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//    }
    
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = Double(latitude)!
        center.longitude = Double(longitude)!
        
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
//                        print(newAddress)
                        self.addressString = newAddress
//                        print(self.addressString)
                  }
//                    print(self.addressString)
            })
        }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let first = locations.first else {
            return
        }
//        first.timestamp
        locationLabel.text = "\(first.coordinate.longitude) | \(first.coordinate.latitude)"
        longitude = "\(first.coordinate.longitude)"
        latitude = "\(first.coordinate.latitude)"
    }
    

    
    @IBAction func onClick(_ sender: Any) {
        print(longitude)
        print(latitude)
        self.getAddressFromLatLon(pdblLatitude: self.latitude, withLongitude: self.longitude)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15, execute: {
            print(self.addressString)
        })
        let user = PFUser.current()!
//        let password = user.password!
        print(user)
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
