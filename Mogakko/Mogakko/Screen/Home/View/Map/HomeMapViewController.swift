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
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { vc, _ in
                let mapLatitude = vc.mapView.centerCoordinate.latitude
                let mapLongitude = vc.mapView.centerCoordinate.longitude
                
                vc.viewModel.requestSearch(request: SearchRequest(lat: mapLatitude, long: mapLongitude)) { error in
                    
                    if let error = error {
                        switch error {
                        case .takenUser, .invalidNickname:
                            return
                        case .invalidAuthorization:
                            vc.showToast(message: "만료된 토큰입니다. 잠시 후 다시 시도해주세요.")
                        case .unsubscribedUser:
                            vc.showToast(message: "미가입 회원입니다.")
                            // TODO: - 회원가입 화면으로 이동
                        case .serverError:
                            vc.showToast(message: "서버 오류입니다. 잠시 후 다시 시도해주세요.")
                        case .emptyParameters:
                            vc.showToast(message: "요청 값이 부족합니다.")
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
                vc.setFromQueueAnnotation(fromQueue)
            }
            .disposed(by: disposeBag)
        
        viewModel.fromRequestedQueue
            .withUnretained(self)
            .bind { vc, fromRequestQueue in
                print("============ 🍀 나에게 요청한 새싹 🍀 ============")
                dump(fromRequestQueue)
            }
            .disposed(by: disposeBag)
        
        totalButton.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                vc.totalButton.isActive = true
                [vc.manButton, vc.womanButton].forEach { $0.isActive = false }
                vc.setFromQueueAnnotation(vc.viewModel.fromQueue.value)
            }
            .disposed(by: disposeBag)
        
        manButton.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                vc.manButton.isActive = true
                [vc.totalButton, vc.womanButton].forEach { $0.isActive = false }
                vc.setFromQueueAnnotation(vc.viewModel.manQueue.value)
            }
            .disposed(by: disposeBag)
        
        womanButton.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                vc.womanButton.isActive = true
                [vc.totalButton, vc.manButton].forEach { $0.isActive = false }
                vc.setFromQueueAnnotation(vc.viewModel.womanQueue.value)
            }
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
                            vc.showToast(message: "만료된 토큰입니다. 잠시 후 다시 시도해주세요.")
                        case .unsubscribedUser:
                            vc.showToast(message: "미가입 회원입니다.")
                        case .serverError:
                            vc.showToast(message: "서버 오류입니다. 잠시 후 다시 시도해주세요.")
                        case .emptyParameters:
                            vc.showToast(message: "요청 값이 부족합니다.")
                        }
                    }
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.requestMyState { [weak self] response, error in
            guard let self = self else { return }
            
            // 201 등의 에러
            if let error = error {
                switch error {
                case .takenUser:
                    // 일반 상태
                    self.floatingButton.type = .plain
                case .invalidNickname:
                    return
                case .invalidAuthorization:
                    print("갱신해라")
                case .unsubscribedUser:
                    return
                case .serverError:
                    self.showToast(message: "서버 에러입니다.")
                case .emptyParameters:
                    self.showToast(message: "요청 값이 부족합니다.")
                }
            }
            
            // 200일 때
            if let response = response {
                if response.matched == 0 {
                    // 매칭 대기중
                    self.floatingButton.type = .matching
                } else {
                    // 매칭된
                    self.floatingButton.type = .matched
                }
            }
        }
    }
    
    private func setFromQueueAnnotation(_ queueList: [FromQueue]) {
        let annotations = mapView.annotations
        mapView.removeAnnotations(annotations)
        
        for queue in queueList {
            let queueCoordinate = CLLocationCoordinate2D(latitude: queue.lat, longitude: queue.long)
            let queueAnnotation = CustomAnnotation(sesac_image: queue.sesac, coordinate: queueCoordinate)
            mapView.addAnnotation(queueAnnotation)
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
