//
//  MapViewController.swift
//  GotoKusakariAPP
//
//  Created by madoka suzuki on 2023/01/19.
//

import UIKit
import MapKit
import Firebase
class MapViewController:UIViewController, UIPickerViewDelegate,UIPickerViewDataSource, MKMapViewDelegate, CLLocationManagerDelegate, UIGestureRecognizerDelegate, UISearchBarDelegate {
    
    @IBOutlet var Mapview: MKMapView!
    @IBOutlet var searchbar: UISearchBar!
    @IBOutlet var locationtextfield: UITextField!
    @IBOutlet var transportation:UITextField!
    let listtransportarion:[String]=["自分で行きます","車で迎えに来てほしい"]
    var Locmanager: CLLocationManager!
    var addressstring = ""
    var pointano: MKPointAnnotation = MKPointAnnotation()
    var annotationlist = [MKPointAnnotation]()
    var pickerview:UIPickerView = UIPickerView()
    override func viewDidLoad() {
        super.viewDidLoad()
        Mapview.delegate = self
       setuplocationmanager()
        searchbar.delegate = self
        searchbar.placeholder = "場所を検索"
        searchbar.autocapitalizationType = UITextAutocapitalizationType.none
        initmap()
        setupscalebar()
        
        pickerview.delegate=self
        pickerview.dataSource=self
        pickerview.showsSelectionIndicator=true
        
        let toolbar1=UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width,height: 35))
        let spaceitem1=UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneitem1=UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
    
        toolbar1.setItems([spaceitem1, doneitem1], animated: true)
        transportation.inputView=pickerview
        transportation.inputAccessoryView=toolbar1
    
        // Do any additional setup after loading the view.
    }
                 
    @objc(numberOfComponentsInPickerView:) func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
        
    }
    @objc func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return listtransportarion.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return listtransportarion[row]
    }
    
    @objc func done(){
            transportation.endEditing(true)
            transportation.text="\(listtransportarion[pickerview.selectedRow(inComponent: 0)])"
                                      }
                                      
    @objc private func mapdidtaped(_ gesture:UITapGestureRecognizer){
        let coordinate = Mapview.convert(gesture.location(in: Mapview), toCoordinateFrom: Mapview)
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        CLGeocoder().reverseGeocodeLocation(location) {[self] placemarks, error in
            guard
                let placemark = placemarks?.first, error == nil,
                let administrativearea = placemark.administrativeArea,
                let locality = placemark.locality,
                let address2 = placemark.thoroughfare,
                let address3 = placemark.subThoroughfare,
                let postalcode = placemark.postalCode,
                let location = placemark.location
                    
            else {
                return
            }
            self.locationtextfield.text = "\(postalcode)\(administrativearea)\(locality)\(address2)\(address3)"
            self.Mapview.removeAnnotations(self.annotationlist)
            pointano.coordinate = coordinate
            self.Mapview.addAnnotation(self.pointano)
        }
    }
    func setuplocationmanager(){
       Locmanager = CLLocationManager()
        guard let locmanager = Locmanager else { return }
        locmanager.requestWhenInUseAuthorization()
        let status = CLLocationManager.authorizationStatus()
        if status == .authorizedWhenInUse{
            locmanager.delegate = self
            locmanager.distanceFilter = 10//m
            locmanager.startUpdatingLocation()
        }
        let gesture = UITapGestureRecognizer(target: self, action: #selector(mapdidtaped(_:)))
        Mapview.addGestureRecognizer(gesture)
    }
    func initmap(){
        let center = CLLocationCoordinate2DMake(32.836123, 128.931016)
        var region: MKCoordinateRegion = Mapview.region
        region.center = center
        region.span.latitudeDelta = 0.5
        region.span.longitudeDelta = 0.5
        Mapview.setRegion(region, animated: true)
    }
    func setupscalebar(){
        let scale = MKScaleView(mapView: Mapview)
        scale.frame.origin.x = 15
        scale.frame.origin.y = 45
        scale.legendAlignment = .leading
        self.view.addSubview(scale)
    }
    func convert(lat:CLLocationDegrees,long:CLLocationDegrees){
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: lat, longitude:long)
        geocoder.reverseGeocodeLocation(location) {placemark, error in
            if let placemark = placemark{
                if let pm = placemark.first{
                    if pm.administrativeArea != nil && pm.locality != nil{
                        self.addressstring = pm.administrativeArea! + pm.locality!
                    }else{
                        self.addressstring = pm.name!
                    }
                }
            }
        }
    }
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchplace(searchText: nil)
        searchBar.text = ""
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchplace(searchText: searchBar.text)
    }
    func searchplace(searchText: String?){
        if let searchKey = searchText{
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(searchKey) { placemarks, error in
                if let unwrapplacemarks = placemarks{
                    if let firstplacemark = unwrapplacemarks.first{
                        if let location = firstplacemark.location{
                            self.Mapview.removeAnnotations(self.annotationlist)
                            self.Mapview.removeAnnotation(self.pointano)
                            let pin = MKPointAnnotation()
                            pin.coordinate = location.coordinate
                            pin.title = searchKey
                            self.Mapview.addAnnotation(pin)
                            self.annotationlist.append(pin)
                            self.Mapview.region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
                        }
                    }
                }
            }
        }
    }
    @IBAction func tonextbutton(){
        UserDefaults.standard.set(self.locationtextfield.text, forKey: "location")
        UserDefaults.standard.set(self.transportation.text, forKey: "transportation")
        
        if (locationtextfield.text == "")&&(transportation.text == "") {
            let alert = UIAlertController(title: "場所と移動手段が選択されていません", message:"", preferredStyle: .alert)
            let okaction = UIAlertAction(title: "OK", style: .default){(action)in
                                                    alert.dismiss(animated: true, completion: nil)
                                                }
                                                alert.addAction(okaction)
            self.present(alert, animated: true, completion: nil)}
        
        
        else if (locationtextfield.text == ""){
            
            let alert = UIAlertController(title: "場所が選択されていません", message:"", preferredStyle: .alert)
            let okaction = UIAlertAction(title: "OK", style: .default){(action)in
                                                    alert.dismiss(animated: true, completion: nil)
                                                }
                                                alert.addAction(okaction)
            self.present(alert, animated: true, completion: nil)}
            
        
        else if (transportation.text == "") {
                                                
              let alert = UIAlertController(title: "移動方法が選択されていません", message:"", preferredStyle: .alert)
              let okaction = UIAlertAction(title: "OK", style: .default){(action)in
                                                    alert.dismiss(animated: true, completion: nil)
                                                }
                                                alert.addAction(okaction)
                self.present(alert, animated: true, completion: nil)}
                                                
        else{
            self.performSegue(withIdentifier: "toconfirm", sender: nil)
        }
    
    
    
    }
}
