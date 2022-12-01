//
//  Background.swift
//  Mogakko
//
//  Created by 소연 on 2022/11/30.
//

import UIKit

@frozen
enum Background {
    case skyPark
    case cityView
    case nightTrail
    case dayTrail
    case theater
    case latin
    case homeTraining
    case musician
    
    var title: String {
        switch self {
        case .skyPark:
            return "하늘 공원"
        case .cityView:
            return "씨티 뷰"
        case .nightTrail:
            return "밤의 산책로"
        case .dayTrail:
            return "낮은 산책로"
        case .theater:
            return "연극 무대"
        case .latin:
            return "라틴 거실"
        case .homeTraining:
            return "홈트방"
        case .musician:
            return "뮤지션 작업실"
        }
    }
    
    var description: String {
        switch self {
        case .skyPark:
            return "새싹들을 많이 마주치는 매력적인 하늘 공원입니다"
        case .cityView:
            return "창밖으로 보이는 도시 야경이 아름다운 공간입니다"
        case .nightTrail:
            return "어둡지만 무섭지 않은 조용한 산책로입니다"
        case .dayTrail:
            return "즐겁고 가볍게 걸을 수 있는 산책로입니다"
        case .theater:
            return "연극의 주인공이 되어 연기를 펼칠 수 있는 무대입니다"
        case .latin:
            return "모노톤의 따스한 감성의 거실로 편하게 쉴 수 있는 공간입니다"
        case .homeTraining:
            return "집에서 운동을 할 수 있도록 기구를 갖춘 방입니다"
        case .musician:
            return "여러가지 음악 작업을 할 수 있는 작업실입니다"
        }
    }
    
    var backgroundImage: UIImage {
        switch self {
        case .skyPark:
            return Constant.Image.backgroundImage1!
        case .cityView:
            return Constant.Image.backgroundImage2!
        case .nightTrail:
            return Constant.Image.backgroundImage3!
        case .dayTrail:
            return Constant.Image.backgroundImage4!
        case .theater:
            return Constant.Image.backgroundImage5!
        case .latin:
            return Constant.Image.backgroundImage6!
        case .homeTraining:
            return Constant.Image.backgroundImage7!
        case .musician:
            return Constant.Image.backgroundImage8!
        }
    }
}
