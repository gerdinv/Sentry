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
            print("UIGestureRecognizerStateEnded")
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let first = locations.first else {
            return
        }
        longitude = "\(first.coordinate.longitude)"
        latitude = "\(first.coordinate.latitude)"
        coordinate = "\(latitude),\(longitude)"
        locationLabel.text = coordinate
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "cancelCallSegue" {
            let destination = segue.destination as! CancelCallViewController
            destination.addressText = self.addressString
            destination.coordinateText = self.coordinate
            destination.lati = self.latitude
            destination.long = self.longitude
        }
    }
}
