//
//  ViewController.swift
//  SendHelp
//
//  Created by Neil Chulani on 2/29/20.
//  Copyright © 2020 Neil Chulani. All rights reserved.
//

import UIKit
import MessageUI
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    let geocoder = CLGeocoder()
    let defaults = UserDefaults.standard
    
    var name = ""
    
    override func viewWillAppear(_ animated: Bool) {
        GetContacts()
        updateScreenContacts()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.locationManager.requestWhenInUseAuthorization()
        locationtest()
        test()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    let bodeid = UserDefaults.standard.string(forKey: "name")
    
    
    
    
    let address = CLGeocoder.init()
    func test() {
    address.reverseGeocodeLocation(CLLocation.init(latitude: 37.369238, longitude:-122.085792)) { (places, error) in
        if error == nil{
            if let place = places{
                //here you can get all the info by combining that you can make address
            }
        }
    }
    }
    
    func locationtest () {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
    }

    var location = [String]()
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        let latitude = String(format:"%f", locValue.latitude)
        location.append(latitude)
        let longitude = String(format:"%f", locValue.longitude)
        location.append(longitude)
        var locationCoordinates = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
    }
    
    

    
    
    @IBOutlet weak var CurrentContacts: UILabel!
    
    func updateScreenContacts () {
        CurrentContacts.text = Contacts.joined(separator:", ")
    }
    
    
    
    
    
    

    
    
    @IBOutlet weak var Pressed: UIButton!
    
    
    var Contacts = [String]()
    func GetContacts() {
        if let x = defaults.array(forKey: "names") {
            Contacts = x as! [String]
        }
    }
    
    @IBOutlet weak var TextField: UITextField!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    
    @IBAction func ConfirmButtonPressed(_ sender: Any) {

        Contacts.append(TextField.text!)
        defaults.set(Contacts, forKey: "names")
        TextField.text = ""
        TextField.resignFirstResponder()
        updateScreenContacts()
    }
    
    
    
    
    @IBAction func ButtonPressed(_ sender: UIButton) {
        locationtest()
        print(bodeid)
        print(location)
        print(address)
        GetContacts()
        print(Contacts)
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = "Please help! I am at these coordinates: \(location[0]) \(location[1])."
            controller.recipients = Contacts
            controller.messageComposeDelegate = self as? MFMessageComposeViewControllerDelegate
            self.present(controller, animated: true, completion: nil)
        }
        else {
            print("Cannot send the message")
        }
        
        func messageComposeViewController(controller: MFMessageComposeViewController!, didFinsihWithResult result: MessageComposeResult) {
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
}

