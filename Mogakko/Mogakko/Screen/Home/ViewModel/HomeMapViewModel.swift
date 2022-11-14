//
//  HomeMapViewModel.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/14.
//

import Foundation
import CoreLocation
import MapKit

import RxCocoa
import RxSwift

final class HomeMapViewModel {
    
    var isLocationEnable = BehaviorRelay<Bool>(value: false)
    
    func setRegion(center: CLLocationCoordinate2D, meters: CLLocationDistance) {
        let region = MKCoordinateRegion(center: center, latitudinalMeters: meters, longitudinalMeters: meters)
//        rootView.mapView.setRegion(region, animated: true)
    }
}
