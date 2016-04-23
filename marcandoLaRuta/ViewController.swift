//
//  ViewController.swift
//  marcandoLaRuta
//
//  Created by Guillermo Asencio Sanchez on 21/4/16.
//  Copyright © 2016 Guillermo Asencio Sanchez. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapa: MKMapView!
    
    @IBOutlet weak var tipoMapaSegmento: UISegmentedControl!
    private let manejador = CLLocationManager()
    
    
    private var puntoSalida: CLLocation? = nil
    private var puntoActual: CLLocation? = nil
    
    private var distanciaRecorrida: Double = 0.00
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manejador.delegate = self
        manejador.desiredAccuracy = kCLLocationAccuracyBest
        manejador.distanceFilter = 50.0
        manejador.requestWhenInUseAuthorization()
        
        if manejador.location?.coordinate != nil {
            puntoSalida = CLLocation(latitude: (manejador.location?.coordinate.latitude)!, longitude: (manejador.location?.coordinate.longitude)!)
            puntoActual = CLLocation(latitude: (manejador.location?.coordinate.latitude)!, longitude: (manejador.location?.coordinate.longitude)!)
            
            distanciaRecorrida = 0.00
            
            var punto = CLLocationCoordinate2D()
            punto.latitude = (manejador.location?.coordinate.latitude)!
            punto.longitude = (manejador.location?.coordinate.longitude)!
            
            let pin = MKPointAnnotation()
            pin.title = "(Longitud: \(round(punto.latitude * 100) / 100), Latitud: \(round(punto.longitude * 100) / 100))"
            pin.subtitle = "Punto de salida"
            pin.coordinate = punto
            mapa.addAnnotation(pin)

        }
        self.centrarMapa()
        self.añadirPin()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse{
            manejador.startUpdatingLocation()
            mapa.showsUserLocation = true
        }else{
            manejador.stopUpdatingLocation()
            mapa.showsUserLocation = false
        }
    }
    
    func centrarMapa(){
        if manejador.location?.coordinate != nil {
            
            if puntoSalida == nil {
                puntoSalida = CLLocation(latitude: (manejador.location?.coordinate.latitude)!, longitude: (manejador.location?.coordinate.longitude)!)
                puntoActual = CLLocation(latitude: (manejador.location?.coordinate.latitude)!, longitude: (manejador.location?.coordinate.longitude)!)
                
                distanciaRecorrida = 0.00
                
                var punto = CLLocationCoordinate2D()
                punto.latitude = (manejador.location?.coordinate.latitude)!
                punto.longitude = (manejador.location?.coordinate.longitude)!
                
                let pin = MKPointAnnotation()
                pin.title = "(Longitud: \(round(punto.latitude * 100) / 100), Latitud: \(round(punto.longitude * 100) / 100))"
                pin.subtitle = "Punto de salida"
                pin.coordinate = punto
                mapa.addAnnotation(pin)
            }
            
            let centro = CLLocationCoordinate2D(latitude: (manejador.location?.coordinate.latitude)!, longitude: (manejador.location?.coordinate.longitude)!)
            let region = MKCoordinateRegion(center: centro, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
            
            self.mapa.setRegion(region, animated: true)
        }

    }
    
    func añadirPin(){
        if manejador.location?.coordinate != nil {
            
            var punto = CLLocationCoordinate2D()
            punto.latitude = (manejador.location?.coordinate.latitude)!
            punto.longitude = (manejador.location?.coordinate.longitude)!
            
            let distancia = abs(round(Double((manejador.location?.distanceFromLocation(puntoActual!))!) * 100) / 100)
            
            if (distancia > 1.0){
                distanciaRecorrida += distancia
                puntoActual = CLLocation(latitude: (manejador.location?.coordinate.latitude)!, longitude: (manejador.location?.coordinate.longitude)!)
                let pin = MKPointAnnotation()
                pin.title = "(Longitud: \(round(punto.latitude * 100) / 100), Latitud: \(round(punto.longitude * 100) / 100))"
                pin.subtitle = "Distancia recorrida: \(distanciaRecorrida) metros"
                pin.coordinate = punto
                mapa.addAnnotation(pin)
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        self.centrarMapa()
        self.añadirPin()
        

    }


    @IBAction func seleccionarMapa(sender: UISegmentedControl) {
        
        switch tipoMapaSegmento.selectedSegmentIndex
        {
        case 0:
            mapa.mapType = MKMapType.Standard
        case 1:
            mapa.mapType = MKMapType.Satellite
        case 2:
            mapa.mapType = MKMapType.Hybrid
        default:
        break;
        }
    }

}

