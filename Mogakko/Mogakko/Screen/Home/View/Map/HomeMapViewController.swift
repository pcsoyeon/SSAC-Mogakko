//
//  HomeViewController.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/11.
//

import UIKit
import MapKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class HomeMapViewController: UIViewController {
    
    // MARK: - UI Property
    
    private var floatingButton = MDSFloatingButton().then {
        $0.type = .plain
    }
    
    private let mapView = MKMapView().then {
        $0.cameraZoomRange = MKMapView.CameraZoomRange(minCenterCoordinateDistance: 500, maxCenterCoordinateDistance: 30000)
    }
    
    private let annotationImageView = UIImageView().then {
        $0.image = Constant.Image.mapMarker
    }
    
    private let genderButtonStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.makeShadow(color: UIColor.black.cgColor, radius: 3, offset: CGSize(width: 0, height: 1), opacity: 0.3)
    }
    
    private let totalButton = MDSFilterButton().then {
        $0.isActive = true
        $0.type = .total
        $0.layer.cornerRadius = 8
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    private let manButton = MDSFilterButton().then {
        $0.isActive = false
        $0.type = .man
    }
    
    private let womanButton = MDSFilterButton().then {
        $0.isActive = false
        $0.type = .woman
        $0.layer.cornerRadius = 8
        $0.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
    private let gpsButton = UIButton().then {
        $0.setImage(Constant.Image.place, for: .normal)
        $0.backgroundColor = .white
        $0.widthAnchor.constraint(equalToConstant: 48).isActive = true
        $0.heightAnchor.constraint(equalToConstant: 48).isActive = true
        $0.makeRound()
        $0.makeShadow(color: UIColor.black.cgColor, radius: 3, offset: CGSize(width: 0, height: 1), opacity: 0.3)
    }
    
    // MARK: - Property
    
    private let viewModel = HomeMapViewModel()
    
    private let disposeBag = DisposeBag()
    
    private let locationManager = CLLocationManager()
    private var currentLocation: CLLocation!
    private let defaultLocationCoordinate = CLLocationCoordinate2D(latitude: 37.516509, longitude: 126.885025)
    
    private var currentLatitude: Double?
    private var currentLongtitude: Double?
    
    private var mapLatitude = 0.0
    private var mapLongitude = 0.0
    
    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        networkMoniter()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAttribute()
        configureHierarchy()
        bind()
        
        setLocation()
        setMapView()
    }
}

extension HomeMapViewController: BaseViewControllerAttribute {
    func configureHierarchy() {
        view.addSubviews(mapView, floatingButton, genderButtonStackView, gpsButton)
        genderButtonStackView.addArrangedSubviews(totalButton, manButton, womanButton)
        mapView.addSubview(annotationImageView)
        
        mapView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        annotationImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        floatingButton.snp.makeConstraints { make in
            make.bottom.trailing.equalTo(view.safeAreaLayoutGuide).inset(Metric.margin)
        }
        
        genderButtonStackView.snp.makeConstraints { make in
            make.top.leading.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        gpsButton.snp.makeConstraints { make in
            make.top.equalTo(genderButtonStackView.snp.bottom).offset(Metric.margin)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(Metric.margin)
        }
    }
    
    func configureAttribute() {
        view.backgroundColor = .darkGray
    }
    
    func bind() {
        mapView.rx.regionDidChangeAnimated
            .throttle(.milliseconds(800), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { vc, _ in
                vc.mapLatitude = vc.mapView.centerCoordinate.latitude
                vc.mapLongitude = vc.mapView.centerCoordinate.longitude
                
                vc.viewModel.requestSearch(request: SearchRequest(lat: vc.mapLatitude, long: vc.mapLongitude)) { error in
                    
                    if let error = error {
                        switch error {
                        case .takenUser, .invalidNickname:
                            return
                        case .invalidAuthorization:
                            vc.showToast(message: "\(String(describing: error.errorDescription))")
                        case .unsubscribedUser:
                            vc.showToast(message: "\(String(describing: error.errorDescription))")
                        case .serverError:
                            vc.showToast(message: "\(String(describing: error.errorDescription))")
                        case .emptyParameters:
                            vc.showToast(message: "\(String(describing: error.errorDescription))")
                        }
                    }
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.fromQueue
            .withUnretained(self)
            .bind { vc, fromQueue in
                print("============ 🌱 주변 새싹 🌱 ============")
                dump(fromQueue)
                
                if vc.viewModel.pressedButtonType.value == .total {
                    vc.setFromQueueAnnotationByGender(MDSFilterType.total.gender, fromQueue)
                } else if vc.viewModel.pressedButtonType.value == .man {
                    vc.setFromQueueAnnotationByGender(MDSFilterType.man.gender, fromQueue)
                } else {
                    vc.setFromQueueAnnotationByGender(MDSFilterType.woman.gender, fromQueue)
                }
                
            }
            .disposed(by: disposeBag)
        
        viewModel.fromRequestedQueue
            .withUnretained(self)
            .bind { vc, fromRequestQueue in
                print("============ 🌱 나에게 요청한 새싹 🌱 ============")
                dump(fromRequestQueue)
            }
            .disposed(by: disposeBag)
        
        Observable
            .merge(
                    totalButton.rx.tap.map { _ in MDSFilterType.total }.startWith(MDSFilterType.total),
                    manButton.rx.tap.map { _ in MDSFilterType.man },
                    womanButton.rx.tap.map { _ in MDSFilterType.woman }
                )
            .withUnretained(self)
            .subscribe(onNext: { vc, type in
                    switch type {
                    case .total:
                        print("✅ - 전체 버튼 탭")
                        vc.totalButton.isActive = true
                        [vc.manButton, vc.womanButton].forEach { $0.isActive = false }
                        vc.setFromQueueAnnotationByGender(MDSFilterType.total.gender, vc.viewModel.fromQueue.value)
                        vc.viewModel.pressedButtonType.accept(MDSFilterType.total)
                        
                    case .man:
                        print("✅ - 남자 버튼 탭")
                        vc.manButton.isActive = true
                        [vc.totalButton, vc.womanButton].forEach { $0.isActive = false }
                        vc.setFromQueueAnnotationByGender(MDSFilterType.man.gender, vc.viewModel.fromQueue.value)
                        vc.viewModel.pressedButtonType.accept(MDSFilterType.man)

                    case .woman:
                        print("✅ - 여자 버튼 탭")
                        vc.womanButton.isActive = true
                        [vc.totalButton, vc.manButton].forEach { $0.isActive = false }
                        vc.setFromQueueAnnotationByGender(MDSFilterType.woman.gender, vc.viewModel.fromQueue.value)
                        vc.viewModel.pressedButtonType.accept(MDSFilterType.woman)
                    }
                })
            .disposed(by: disposeBag)
        
        gpsButton.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                if let latitude = vc.currentLatitude, let longtitude = vc.currentLongtitude {
                    let center = CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
                    vc.mapView.setRegion(MKCoordinateRegion(center: center , span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: true)
                }
                
                let mapLatitude = vc.mapView.centerCoordinate.latitude
                let mapLongitude = vc.mapView.centerCoordinate.longitude
                
                vc.viewModel.requestSearch(request: SearchRequest(lat: mapLatitude, long: mapLongitude)) { error in
                    
                    if let error = error {
                        switch error {
                        case .takenUser, .invalidNickname:
                            return
                        case .invalidAuthorization:
                            vc.showToast(message: error.errorDescription ?? "")
                        case .unsubscribedUser:
                            vc.showToast(message: error.errorDescription ?? "")
                        case .serverError:
                            vc.showToast(message: error.errorDescription ?? "")
                        case .emptyParameters:
                            vc.showToast(message: error.errorDescription ?? "")
                        }
                    }
                }
            }
            .disposed(by: disposeBag)
        
        floatingButton.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                if vc.floatingButton.type == .plain {
                    let viewController = StudyViewController()
                    viewController.mapLatitude = vc.mapLatitude
                    viewController.mapLongitude = vc.mapLongitude
                    vc.navigationController?.pushViewController(viewController, animated: true)
                } else if vc.floatingButton.type == .matching {
                    // 매칭중
                } else {
                    // 매칭된
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func setFromQueueAnnotationByGender(_ gender: Int, _ queueList: [FromQueue]) {
        let annotations = mapView.annotations
        mapView.removeAnnotations(annotations)
        
        if gender == 2 {
            for queue in queueList {
                print("✨ - \(queue)")
                let queueCoordinate = CLLocationCoordinate2D(latitude: queue.lat, longitude: queue.long)
                let queueAnnotation = CustomAnnotation(sesac_image: queue.sesac, coordinate: queueCoordinate)
                mapView.addAnnotation(queueAnnotation)
            }
            
            return
        }
        
        for queue in queueList {
            if queue.gender == gender {
                print("✨ - \(queue)")
                let queueCoordinate = CLLocationCoordinate2D(latitude: queue.lat, longitude: queue.long)
                let queueAnnotation = CustomAnnotation(sesac_image: queue.sesac, coordinate: queueCoordinate)
                mapView.addAnnotation(queueAnnotation)
            }
        }
    }
}

// MARK: - Location

extension HomeMapViewController {
    func setLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        currentLocation = locationManager.location
    }
    
    func setMapView() {
        mapView.setRegion(MKCoordinateRegion(center: defaultLocationCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: true)
        
        mapView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    }
}

// MARK: - Location Service Authoriztaion

extension HomeMapViewController {
    
    func checkUserLocationServiceAuthoriztaion() {
        let authorizationStatus : CLAuthorizationStatus
        
        if #available(iOS 14.0, *){
            authorizationStatus = locationManager.authorizationStatus
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        
        if CLLocationManager.locationServicesEnabled() {
            checkCurrentLocationAuthorization(authorizationStatus)
        } else {
            showToast(message: "iOS 위치 서비스를 켜주세요")
        }
    }
    
    func checkCurrentLocationAuthorization(_ authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
        case .notDetermined:
            print("notDetermined")
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        case .restricted, .denied:
            print("LocationDisable")
            viewModel.isLocationEnable.accept(false)
            presentSettingAlert()
        case .authorizedAlways, .authorizedWhenInUse:
            print("LocationEnable")
            viewModel.isLocationEnable.accept(true)
            locationManager.startUpdatingLocation()
        @unknown default:
            print("unknown")
        }
    }
}

extension HomeMapViewController: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkUserLocationServicesAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkUserLocationServicesAuthorization()
    }
    
    func checkUserLocationServicesAuthorization() {
        let authorizationStatus: CLAuthorizationStatus
        if #available(iOS 14, *) {
            authorizationStatus = locationManager.authorizationStatus
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        
        if CLLocationManager.locationServicesEnabled() {
            checkCurrentLocationAuthorization(authorizationStatus)
        }
    }
    
    func presentSettingAlert() {
        let requestLocationServiceAlert = UIAlertController(title: "위치정보 이용", message: "위치 서비스를 사용할 수 없습니다. 기기의 '설정 > 개인정보 보호'에서 위치 서비스를 켜주세요.", preferredStyle: .alert)
        
        let openSetting = UIAlertAction(title: "설정으로 이동", style: .destructive) { _ in
            if let appSetting = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSetting)
            }
        }
        
        let cancel = UIAlertAction(title: "취소", style: .default)
        requestLocationServiceAlert.addAction(cancel)
        requestLocationServiceAlert.addAction(openSetting)
        
        present(requestLocationServiceAlert, animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.last?.coordinate {
            mapView.setRegion(MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: true)
            
            currentLatitude = coordinate.latitude
            currentLongtitude = coordinate.longitude
            
            
        }
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function, error)
    }
}

// MARK: - MapKit Protocol

extension HomeMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? CustomAnnotation else {
            return nil
        }
        
        var annotationView = self.mapView.dequeueReusableAnnotationView(withIdentifier: CustomAnnotationView.identifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: CustomAnnotationView.identifier)
            annotationView?.canShowCallout = false
            annotationView?.contentMode = .scaleAspectFit
            
        } else {
            annotationView?.annotation = annotation
        }
        
        let sesacImage: UIImage!
        let size = CGSize(width: 85, height: 85)
        UIGraphicsBeginImageContext(size)
        
        sesacImage = SesacImage(rawValue: annotation.sesac_image ?? 0)?.sesacUIImage()
        
        sesacImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        annotationView?.image = resizedImage
        
        return annotationView
    }
}
