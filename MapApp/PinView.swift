//
//  PinView.swift
//  MapApp
//
//  Created by Maiqui Cedeño on 4/11/18.
//  Copyright © 2018 Poseto Studio. All rights reserved.
//

import Foundation
import MapKit //Framework para el manejo de mapas.

//MKAnnotation es un protocolo que se utliza para asociar contenido a una ubicacion de mapa especifica.
class PinView: NSObject, MKAnnotation
{
    //MKAnnotation obliga a implementar la variable de instancia coordinate, la cual es el punto medio de la anotacion expresada en coordenadas.
    //CLLocationCoordinate2D es una estructura, la cual tiene como elementos longitude y latitude, que son del tipo CLlocationDegrees
    var coordinate: CLLocationCoordinate2D
    var title:String?                   //Titulo de pin.
    
    //MKAnnotation no tiene constructor o inicializador, por lo cual debemos implementarlo.
    init(_coordinate: CLLocationCoordinate2D)
    {
        self.coordinate = _coordinate
    }
    
    func setTitle(_title: String)
    {
        self.title = _title
    }
}
