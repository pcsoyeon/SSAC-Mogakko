//
//  CustomAnnotation.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/17.
//

import Foundation

import CoreLocation
import MapKit

enum SesacImage : Int {
    case sesac0
    case sesac1
    case sesac2
    case sesac3
    case sesac4
    
    func sesacUIImage() -> UIImage{
        return UIImage(named: "sesac_face_\(self.rawValue + 1)")!
    }
}


class CustomAnnotation: NSObject, MKAnnotation {
    let sesac_image: Int?
    let coordinate: CLLocationCoordinate2D
    
    init(
        sesac_image: Int?,
        coordinate: CLLocationCoordinate2D
    ) {
        self.sesac_image = sesac_image
        self.coordinate = coordinate
        
        super.init()
    }
    
}

class CustomAnnotationView: MKAnnotationView {
    static let identifier = "CustomAnnotationView"
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?){
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        frame = CGRect(x: 0, y: 0, width: 40, height: 50)
        centerOffset = CGPoint(x: 0, y: -frame.size.height / 2)
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
