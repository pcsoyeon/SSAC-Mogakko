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
    
    private let genderButtonStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillEqually
        
        // TODO: - 둘 중에 하나만 적용 .. 어떻게 해결 ??
        $0.makeRound()
    }
    
    private let totalButton = MDSFilterButton().then {
        $0.isActive = true
        $0.type = .total
    }
    
    private let manButton = MDSFilterButton().then {
        $0.isActive = false
        $0.type = .man
    }
    
    private let womanButton = MDSFilterButton().then {
        $0.isActive = false
        $0.type = .woman
    }
    
    private let qpsButton = UIButton().then {
        $0.setImage(Constant.Image.place, for: .normal)
        $0.backgroundColor = .white
        $0.widthAnchor.constraint(equalToConstant: 48).isActive = true
        $0.heightAnchor.constraint(equalToConstant: 48).isActive = true
        $0.makeRound()
    }
    
    // MARK: - Property
    
    private let viewModel = HomeMapViewModel()
    
    private let disposeBag = DisposeBag()
    
    private let locationManager = CLLocationManager()
    private var currentLocation: CLLocation!
    private let defaultLocationCoordinate = CLLocationCoordinate2D(latitude: 37.516509, longitude: 126.885025)
    
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
    }
}

extension HomeMapViewController: BaseViewControllerAttribute {
    func configureHierarchy() {
        view.addSubviews(mapView, floatingButton, genderButtonStackView, qpsButton)
        genderButtonStackView.addArrangedSubviews(totalButton, manButton, womanButton)
        
        mapView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        floatingButton.snp.makeConstraints { make in
            make.bottom.trailing.equalTo(view.safeAreaLayoutGuide).inset(Metric.margin)
        }
        
        genderButtonStackView.snp.makeConstraints { make in
            make.top.leading.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        qpsButton.snp.makeConstraints { make in
            make.top.equalTo(genderButtonStackView.snp.bottom).offset(Metric.margin)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(Metric.margin)
        }
    }
    
    func configureAttribute() {
        view.backgroundColor = .darkGray
    }
    
    func bind() {
        mapView.rx.regionDidChangeAnimated
            .subscribe(onNext: { _ in
                print("💨 맵 움직인다 !!!!")
            })
            .disposed(by: disposeBag)
        
        totalButton.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                vc.totalButton.isActive = true
                [vc.manButton, vc.womanButton].forEach { $0.isActive = false }
            }
            .disposed(by: disposeBag)
        
        manButton.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                vc.manButton.isActive = true
                [vc.totalButton, vc.womanButton].forEach { $0.isActive = false }
            }
            .disposed(by: disposeBag)
        
        womanButton.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                vc.womanButton.isActive = true
                [vc.totalButton, vc.manButton].forEach { $0.isActive = false }
            }
            .disposed(by: disposeBag)
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
        
        mapView.setRegion(MKCoordinateRegion(center: defaultLocationCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: true)
        
//        mapView.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: CustomAnnotationView.identifier)
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
            //            viewModel.calculateRegion(lat: 37.517819364682694, long: 126.88647317074734)
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
            // TODO: - 가까운 친구 찾기
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
        }
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function, error)
    }
}
