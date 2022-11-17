//
//  RxMKMapViewDelegateProxy.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/14.
//

import Foundation
import MapKit

import RxCocoa
import RxSwift

func castOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T {
    guard let returnValue = object as? T else {
        throw RxCocoaError.castingError(object: object, targetType: resultType)
    }
    return returnValue
}

final class RxMKMapViewDelegateProxy: DelegateProxy<MKMapView, MKMapViewDelegate>, DelegateProxyType, MKMapViewDelegate {
    static func registerKnownImplementations() {
        self.register { (mapView) -> RxMKMapViewDelegateProxy in
            RxMKMapViewDelegateProxy(parentObject: mapView, delegateProxy: self)
        }
    }
    
    static func currentDelegate(for object: MKMapView) -> MKMapViewDelegate? {
        return object.delegate
    }
    
    static func setCurrentDelegate(_ delegate: MKMapViewDelegate?, to object: MKMapView) {
        object.delegate = delegate
    }
}

extension Reactive where Base: MKMapView {
    var delegate : DelegateProxy<MKMapView, MKMapViewDelegate> {
        return RxMKMapViewDelegateProxy.proxy(for: self.base)
    }
    
    var regionDidChangeAnimated: ControlEvent<Bool> {
        let source = delegate
            .methodInvoked(#selector(MKMapViewDelegate.mapView(_:regionDidChangeAnimated:)))
            .map { a in
                return try castOrThrow(Bool.self, a[1])
            }
        return ControlEvent(events: source)
    }
    
    var didChangeUserTrackingMode: ControlEvent<(mode: MKUserTrackingMode, animated: Bool)> {
        let source = delegate
            .methodInvoked(#selector(MKMapViewDelegate.mapView(_:didChange:animated:)))
            .map { a in
                return (mode: try castOrThrow(Int.self, a[1]),
                        animated: try castOrThrow(Bool.self, a[2]))
            }
            .map { (mode, animated) in
                return (mode: MKUserTrackingMode(rawValue: mode)!,
                        animated: animated)
            }
        return ControlEvent(events: source)
    }
    
    var didAddAnnotationViews: ControlEvent<[MKAnnotationView]> {
        let selector: Selector
        #if swift(>=5.7)
        selector = #selector(
            (MKMapViewDelegate.mapView(_:didAdd:))
            as (MKMapViewDelegate) -> ((MKMapView, [MKAnnotationView]) -> Void)?
        )
        #else
        selector = #selector(
            (MKMapViewDelegate.mapView(_:didAdd:))!
            as (MKMapViewDelegate) -> (MKMapView, [MKAnnotationView]) -> Void
        )
        #endif
        let source = delegate
            .methodInvoked(selector)
            .map { a in
                return try castOrThrow([MKAnnotationView].self, a[1])
            }
        return ControlEvent(events: source)
    }
    
    func setDelegate(_ delegate: MKMapViewDelegate)
    -> Disposable {
        return RxMKMapViewDelegateProxy.installForwardDelegate(delegate, retainDelegate: false, onProxyForObject: self.base)
    }
}
