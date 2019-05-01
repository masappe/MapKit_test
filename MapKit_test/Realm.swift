//
//  Realm.swift
//  MapKit_test
//
//  Created by Masato Hayakawa on 2019/04/30.
//  Copyright © 2019 masappe. All rights reserved.
//

import Foundation
import RealmSwift
import MapKit

class LocationsPoints: Object {
    @objc dynamic var latitude: CLLocationDegrees = 0
    @objc dynamic var longitude: CLLocationDegrees = 0
}
