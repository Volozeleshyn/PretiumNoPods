//
//  MapViewController.swift
//  Pretium
//
//  Created by Alexey Zelentsov on 18/05/2019.
//  Copyright © 2019 Alexey Zelentsov. All rights reserved.
//

import UIKit
import Mapbox
import MapboxCoreNavigation
import MapboxNavigation
import MapboxDirections

class MapViewController: UIViewController, MGLMapViewDelegate, CLLocationManagerDelegate {

 /*   var mapview: NavigationMapView!
    var followButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapview = NavigationMapView(frame: view.bounds, styleURL: URL(fileURLWithPath: "mapbox://styles/yakovbrill/cju1laagi1dwu1flrzi4y4poq"))
        mapview.autoresizingMask = [ .flexibleWidth , .flexibleHeight]
        view.addSubview(mapview)
        mapview.delegate = self
        mapview.showsUserLocation = true
        mapview.setUserTrackingMode(.follow, animated: true)
        self.addButton()
        //Kremlin
        let center = CLLocationCoordinate2D(latitude: 55.751694, longitude: 37.617218)
        
        mapview.setCenter(center, zoomLevel: 7, direction: 0, animated: false)
        
        let hello = MGLPointAnnotation()
        hello.coordinate = CLLocationCoordinate2D(latitude: 55.751694, longitude: 37.617218)
        hello.title = "Hello world!"
        hello.subtitle = "Pretium"
        
        mapview.addAnnotation(hello)
    }
    func addButton() {
        followButton = UIButton(frame: CGRect(x:(view.frame.width/2)-100,y:view.frame.height - 75 , width:200 , height: 50))
        followButton.backgroundColor = UIColor.white
        followButton.setTitle("FOLLOW" , for: .normal)
        followButton.setTitleColor(UIColor(red:59/255, green: 178/255, blue: 208/255 , alpha :1 ), for: .normal)
        followButton.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 18)
        followButton.layer.cornerRadius = 25
        followButton.layer.shadowOffset = CGSize(width: 0, height: 10)
        followButton.layer.shadowRadius = 5
        followButton.layer.shadowOpacity = 0.3
        followButton.addTarget(self, action: #selector(followButtonWasPressed(_:)), for: .touchUpInside)
        view.addSubview(followButton)
    }
    
    @objc func followButtonWasPressed(_ sender:UIButton) {
        
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        let camera = MGLMapCamera(lookingAtCenter: mapView.centerCoordinate, altitude: 4500, pitch: 15, heading: 180)
        
        mapView.setCamera(camera, withDuration: 5, animationTimingFunction: CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut))
    } */
        
        
    
    @IBOutlet weak var mapView: MGLMapView!
    var followButton : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.delegate = self
        
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true)
       
        self.addButton()
        
        //Kremlin
        let center = CLLocationCoordinate2D(latitude: 55.751694, longitude: 37.617218)
        
        mapView.setCenter(center, zoomLevel: 7, direction: 0, animated: false)
        
        let hello = MGLPointAnnotation()
        hello.coordinate = CLLocationCoordinate2D(latitude: 55.751694, longitude: 37.617218)
        hello.title = "Hello world!"
        hello.subtitle = "Pretium"
        
        mapView.addAnnotation(hello)
        
        
        
    }
    
    
    func addButton() {
        followButton = UIButton(frame: CGRect(x:(view.frame.width/2)-100,y:view.frame.height - 75 , width:200 , height: 50))
        followButton.backgroundColor = UIColor.white
        followButton.setTitle("FOLLOW" , for: .normal)
        followButton.setTitleColor(UIColor(red:59/255, green: 178/255, blue: 208/255 , alpha :1 ), for: .normal)
        followButton.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 18)
        followButton.layer.cornerRadius = 25
        followButton.layer.shadowOffset = CGSize(width: 0, height: 10)
        followButton.layer.shadowRadius = 5
        followButton.layer.shadowOpacity = 0.3
        followButton.addTarget(self, action: #selector(followButtonWasPressed(_:)), for: .touchUpInside)
        view.addSubview(followButton)
    }
    
    @objc func followButtonWasPressed(_ sender:UIButton) {
        
        let loc = mapView.userLocation?.coordinate
        
        let camera = MGLMapCamera(lookingAtCenter: loc ?? CLLocationCoordinate2D(latitude: 55.751694, longitude: 37.617218), altitude: 4500, pitch: 15, heading: 180)
        
        mapView.setCamera(camera, withDuration: 0.1, animationTimingFunction: CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut))
    }
    
    private func locationManagerTools() {
        
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        let camera = MGLMapCamera(lookingAtCenter: mapView.centerCoordinate, altitude: 4500, pitch: 15, heading: 180)
        
        mapView.setCamera(camera, withDuration: 5, animationTimingFunction: CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut))
    }
    
    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
        guard let image = UIImage(named: "Fb") else {return MGLAnnotationImage()}
        
        let ret = MGLAnnotationImage(image: image, reuseIdentifier: "Fb")
        return ret
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    

}