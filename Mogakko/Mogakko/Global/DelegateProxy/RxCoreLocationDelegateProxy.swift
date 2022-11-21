//
//  RxCoreLocationDelegateProxy.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/18.
//

import Foundation
import CoreLocation

import RxCocoa
import RxSwift

final class CLLocationManagerDelegateProxy: DelegateProxy<CLLocationManager, CLLocationManagerDelegate>, DelegateProxyType, CLLocationManagerDelegate {
    public weak private(set) var locationManager: CLLocationManager?
    
    public init(locationManager: CLLocationManager) {
        self.locationManager = locationManager
        super.init(parentObject: locationManager, delegateProxy: CLLocationManagerDelegateProxy.self)
    }
    
    static func registerKnownImplementations() {
        self.register { CLLocationManagerDelegateProxy(locationManager: $0) }
    }
    
    static func currentDelegate(for object: CLLocationManager) -> CLLocationManagerDelegate? {
        return object.delegate
    }
    
    static func setCurrentDelegate(_ delegate: CLLocationManagerDelegate?, to object: CLLocationManager) {
        object.delegate = delegate
    }
    
}

extension Reactive where Base: CLLocationManager {
    fileprivate var locationManagerDelegateProxy: DelegateProxy<CLLocationManager, CLLocationManagerDelegate> {
        return CLLocationManagerDelegateProxy.proxy(for: base)
    }
    
    var didUpdateLocations: Observable<CLLocationCoordinate2D> {
        let selector = #selector(CLLocationManagerDelegate.locationManager(_:didUpdateLocations:))
        return locationManagerDelegateProxy.methodInvoked(selector)
            .map({ (params) -> CLLocationCoordinate2D in
                return (params[1] as! [CLLocation]).first!.coordinate
            })
    }
}
