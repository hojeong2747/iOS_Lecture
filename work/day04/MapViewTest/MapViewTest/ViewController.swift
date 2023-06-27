//
//  ViewController.swift
//  MapViewTest
//
//  Created by Dongduk1 on 2023/06/27.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet var myMap: MKMapView!
    @IBOutlet var lblLocationInfo1: UILabel!
    @IBOutlet var lblLocationInfo2: UILabel!
    
    let locationManager = CLLocationManager() // 지도 로딩만 delegate
    // 지도 정보를 주는 클래스에서 객체 생성
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        lblLocationInfo1.text = ""
        lblLocationInfo2.text = ""
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation() // 이때부터 위치 정보 수신
        myMap.showsUserLocation = true // 사용자 위치 정보 보여주기 활성화 (아직 지도에 표시 x)
    }

    @IBAction func sgChangeLocation(_ sender: UISegmentedControl) {
    }
    
    func goLocation(latitudeValue: CLLocationDegrees, longitudeValue: CLLocationDegrees, delta span: Double) { // 위도, 경도, 확대 배율
        let pLocation = CLLocationCoordinate2DMake(latitudeValue, longitudeValue) // 2차원 위치 좌표
        let spanValue = MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span) // 위도, 경도 상 확대 배율 설정
        let pRegion = MKCoordinateRegion(center: pLocation, span: spanValue) // 위 두 객체 정보를 사용해 내가 봐야 할 위치 정보 설정
        myMap.setRegion(pRegion, animated: true) // 화면 지도 상에 지역 설정하고, 효과를 주는 매개변수 설정
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) { // locations: 위치 정보가 업데이트 될 때마다 호출됨. 최신의 위치 정보로 goLocation 호출 -> 지도가 움직여
        let pLocation = locations.last // 전달 받은 locations의 위치 정보. 가장 마지막 정보(못 받았을 경우) or 갱신받은 정보
        goLocation(latitudeValue: (pLocation?.coordinate.latitude)!, longitudeValue: (pLocation?.coordinate.longitude)!, delta: 0.01)
    }
    
}

