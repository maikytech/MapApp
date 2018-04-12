//
//  MapViewController.swift
//  MapApp
//
//  Created by Maiqui Cedeño on 4/11/18.
//  Copyright © 2018 Poseto Studio. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

//El protocolo CLLocationManagerDelegate incluye metodos que se usan para la localizacion.
//El protocolo MKMapView contiene metodos relacionados con la actualizacion de los mapas.
class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate
{
   
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var centrarButton: UIButton!
    @IBOutlet weak var etiquetaDistancia: UILabel!
    @IBOutlet weak var etiquetaDireccion: UILabel!
    @IBOutlet weak var etiquetaCoordenadasUsuario: UILabel!
    
    //Se crea un objeto de la clase CLLocationManager.
    //El objeto de la clase CLLocationManager configura, comienza y termina los servicios de localizacion.
    let locationManager = CLLocationManager()
    
    //Tupla de coordenadas aleatorias para colocar pines en el mapa.
    let coordenadas = [(4.6948, -74.808), (4.7313, -74.0660), (4.7016, -74.0974), (4.726123, -74.0360)]
    
    //viewDidAppear es llamado cuando todos los elementos visuales iniciales ya se han cargado en la pantalla.
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        //Recordemos que self es un puntero a un objeto estatico tipificado con la clase sobre la que se ejecuta el metodo.
        locationManager.delegate = self         //Indicamos que el delegado de la localizacion será la misma clase.
        mapView.delegate = self                 //Se asigna el delegado de la vista del mapa a la clase.
        
        //A traves de este bloque if nos aseguramos que la App tenga la autorización apropiada de localización del usuario.
        //authorizationStatus() es un metodo estatico o de clase, el cual retorna el status de la autorizacion de localización.
        if CLLocationManager.authorizationStatus() == .notDetermined
        {
            //requestWhenInUseAuthorization es un metodo de instancia que solicita permiso de localizacion mientras la app este en primer plano.
            locationManager.requestWhenInUseAuthorization()
            
        }else if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            
            // mapView.showsUserLocation = true        //Muestra la localizacion del usuario.
            
            //startUpdatingLocation es un metodo que inicia la generacion de actualizaciones de la posicion del usuario.
            locationManager.startUpdatingLocation()
            
            //desiredAccuracy es una variable de instancia de la clase CLLocationManager que contiene la exactitud de la data.
            //desiredAccuracy es del tipo CLLocationAccuracy, el cual es un typealias de un valor Double.
            //kCLLocationAccuracyKilometer es una variable global de la clase CLLocation del tipo CLLocationAccuracy, el cual coloca la exactitud de la posicion en kilometros.
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        }
        
        //A traves de este ciclo for colocamos pines en el mapa.
        for (latitud, longitud) in coordenadas
        {
            //PinView es una clase creada en este proyecto para configurar la craciones de pines a colocar en el mapa.
            //init es el construtor de la clase PinView, el cual tiene como parametro un objeto CLLocationCoordinate2D.
            //CLLocationCoordinate2D es una estructura, la cual tiene como elementos longitude y latitude, que son del tipo CLlocationDegrees
            //CLlocationDegrees es una alias para valores de longitud y latitud en grados tipo Double.
            let newPin = PinView.init(_coordinate: CLLocationCoordinate2D (latitude: latitud, longitude: longitud))
            newPin.setTitle(_title: "Pin")
            
            //addAnnotation es un metodo de instancia que agrega la anotacion en el map view, tiene como parametro un objeto MKAnnotation
            mapView.addAnnotation(newPin)       //Agregamos la anotacion a la vista del mapa.
        }
    }
    
    //Accion del boton centrar.
    @IBAction func centrarPressed(_ sender: UIButton)
    {
        mapView.centerCoordinate = mapView.userLocation.coordinate      //Asigna las coordenadas de la ubicación del usuario al centro del mapa.
        sender.isHidden = true                                          //Se oculta el boton.
    }
    
    //Esta función nos indica si el permiso de localización ha cambiado.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        if(status == .authorizedWhenInUse)  //Si esta activo el permiso de localizacion mientras se usa la applicacion...
        {
            // mapView.showsUserLocation = true        //Muestra la localizacion del usuario.
            
            //startUpdatingLocation es un metodo que inicia la generacion de actualizaciones de la posicion del usuario.
            manager.startUpdatingLocation()
            
            //desiredAccuracy es una variable de instancia de la clase CLLocationManager que contiene la exactitud de la data.
            //desiredAccuracy es del tipo CLLocationAccuracy, el cual es un typealias de un valor Double.
            //kCLLocationAccuracyKilometer es una variable global de la clase CLLocation del tipo CLLocationAccuracy, el cual coloca la exactitud de la posicion en kilometros.
            manager.desiredAccuracy = kCLLocationAccuracyKilometer
        }
    }
    
    //Esta funcion le indica al locationManager si el usuario tiene una nueva localizacion, utilizando un array de localizaciones.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //locations es el array donde se encuentran las localizaciones del usuario.
        let userLocation = locations.first
        
        let latitudeGPS = userLocation?.coordinate.latitude
        let longitudeGPS = userLocation?.coordinate.longitude
        etiquetaCoordenadasUsuario.text = "Las coordenadas actuales del usuario son Lat: \(latitudeGPS!)  Long: \(longitudeGPS!)"
    }
    
    //Esta función le indica al delegate si la región del mapa cambio.
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool)
    {
        let latitud = mapView.centerCoordinate.latitude         //Constante de la clase CLlocationDegrees
        let longitud = mapView.centerCoordinate.longitude
        
        //Se imprimen la coordenadas del centro de la region.
        print("Longitud del centro de la region actual: \(longitud)\n Latitud del centro de la region actual: \(latitud)\n" )
        
        //El boton de centrar aparecera cada que el centro de la región sea diferente de la posicion del usuario.
        if ((latitud != mapView.userLocation.coordinate.latitude) && (longitud != mapView.userLocation.coordinate.longitude))
        {
            centrarButton.isHidden = false
        }
        
        //Variable tipo CLlocation que contendra las coordenadas del punto centrar donde se movio el mapa.
        let locationCoordinates = CLLocation(latitude: latitud, longitude: longitud)
        
        //Distancia desde la ubicacion del usuario hasta el punto central donde se movio el mapa.
        //El metodo de instancia distance retorna la distancia en metros tipo CLLocationDistance desde el objeto que llama el metodo hasta el parametro tipo CLLocation.
        let distanceInMeeters = mapView.userLocation.location?.distance(from: locationCoordinates)
        
        if(distanceInMeeters != nil)
        {
            etiquetaDistancia.text = "La distancia desde la ubicación del usuario y el punto del mapa es: \(distanceInMeeters!)"
            
            //Se llama al metodo geocode.
            self.geocode(latitude: latitud, longitude: longitud)
        }else{
            
            etiquetaDistancia.text = "No se pudo obtener ninguna distancia"
        }
    }
    
    //Función que configura la obtencion de geo informacion de las coordenadas geograficas.
    func geocode(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        
        //Constante que contiene las coordenadas para las solicitudes de geocider.
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        //La clase CLGeocoder contiene metodos para convertir coordenadas a nombre de lugares y viceversa.
        let geocoder = CLGeocoder()
        
        //El metodo reverseGeocodeLocation envia una solicitud geocoding inversa, cuando esta solicitud es completada, se ejecuta el completionHandler.
        //El completionHandler tiene dos parametros que pueden opcionales que pueden ser utilizados en este closure, los cuales son:
        //placemark, el cual es una array tipo CLPlacemark, los cuales son objetos que describen el lugar que marcan las coordenadas, como nombre, direccion y otra informacion relevante.
        //error, este parametro contiene nil o un objeto indicando porque la info del placemark no retorno.
        geocoder.reverseGeocodeLocation(location, completionHandler: {(placemarks,error) in
            if placemarks != nil{
                
                //Asignamos a la variante placemark el primer objeto del array placemarks, el cual es del tipo CLPlacemark.
                //Los objetos de la clase CLPlacemark son objetos descriptivos, con informacion relevante de coordenadas geograficas.
                let placemark = placemarks?.first
                
                //Se asigna a la etiqueta de direccion el nombre de la coordenada geografica dada.
                self.etiquetaDireccion.text = placemark?.name
                
            } else{
                
                //En un closure cualquier referencia necesita explicitamente ser direccionado a la clase a traves del puntero self.
                self.etiquetaDireccion.text = "No se pudo obtener ningun dato"
            }
        })
        
        
        
    }
}

