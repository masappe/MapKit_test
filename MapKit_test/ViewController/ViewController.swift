//
//  ViewController.swift
//  MapKit_test
//
//  Created by Masato Hayakawa on 2019/04/29.
//  Copyright © 2019 masappe. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import RealmSwift


class ViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var informationLabel: UILabel!
    var locationManager: CLLocationManager!
    var points = [MKMapPoint]()
    var latitude: CLLocationDegrees!
    var longitude: CLLocationDegrees!

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        setLocationInformation()
        
    }
    
    func setLocationInformation() {
        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 100
        locationManager.delegate = self
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    }
    
    @IBAction func createLine(_ sender: Any) {
        //線の作成
        let realm = try! Realm()
        let locationData = realm.objects(LocationsPoints.self)
        for i in locationData {
            points.append(MKMapPoint(CLLocationCoordinate2DMake(i.latitude,i.longitude)))
        }
        let line = MKPolyline(points: points, count: points.count)
        mapView.addOverlay(line)
    }
    
    //線の情報
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay)
        render.lineWidth = 3
        render.strokeColor = .red
        return render
        
    }
    
    @IBAction func moveMap(_ sender: Any) {
        //現在地に移動
        let center = CLLocationCoordinate2DMake((locationManager.location?.coordinate.latitude)!, (locationManager.location?.coordinate.longitude)!)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    @IBAction func getAllAnnotation(_ sender: Any) {
        //全てのアンテナを打つ
        let realm = try! Realm()
        let locationData = realm.objects(LocationsPoints.self)
        for i in locationData {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2DMake(i.latitude, i.longitude)
            mapView.addAnnotation(annotation)
        }
    }
    
    @IBAction func getAnnotation(_ sender: Any) {
        //mapにアンテナを打つ
        let annotation = MKPointAnnotation()
        latitude = locationManager.location?.coordinate.latitude
        longitude = locationManager.location?.coordinate.longitude
        annotation.coordinate = CLLocationCoordinate2DMake(latitude!,longitude!)
        mapView.addAnnotation(annotation)
        //realmにデータの書き込み
        let Data = LocationsPoints()
        Data.latitude = latitude
        Data.longitude = longitude
        let realm = try! Realm()
        try! realm.write {
            realm.add(Data)
        }
        print(realm.objects(LocationsPoints.self))
        
    }
    
    @IBAction func startButton(_ sender: Any) {
        //位置情報の取得
        locationManager.startUpdatingLocation()
        let latitude = locationManager.location?.coordinate.latitude
        let longitude = locationManager.location?.coordinate.longitude
        informationLabel.text = "latitude:\(latitude)\nlongitude:\(longitude)"
    }
    
    @IBAction func stopButton(_ sender: Any) {
        //位置情報取得の終了
        locationManager.stopUpdatingLocation()
    }
    
}

