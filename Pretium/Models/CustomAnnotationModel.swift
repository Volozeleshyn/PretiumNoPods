//
//  CustomAnnotationModel.swift
//  Pretium
//
//  Created by artikbartez on 14.07.2019.
//  Copyright © 2019 Alexey Zelentsov. All rights reserved.
//

import Foundation
import Mapbox
class CustomAnnotation: NSObject, MGLAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var image: UIImage?
    //
    init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
}

