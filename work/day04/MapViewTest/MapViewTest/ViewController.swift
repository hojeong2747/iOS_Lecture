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
        locationManager.startUpdatingLocation() // 이때부터 위치 정보 수신 (현재 위치 받기 시작하면, locationManager 수행되는데, 그 안에서 멈췄기 때문에 다시 0번 부분에 넣어주면 됨)
        myMap.showsUserLocation = true // 사용자 위치 정보 보여주기 활성화 (아직 지도에 표시 x)
    }
    
    func goLocation(latitudeValue: CLLocationDegrees, longitudeValue: CLLocationDegrees, delta span: Double)
    -> CLLocationCoordinate2D { // 위도, 경도, 확대 배율
        let pLocation = CLLocationCoordinate2DMake(latitudeValue, longitudeValue) // 2차원 위치 좌표
        let spanValue = MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span) // 위도, 경도 상 확대 배율 설정
        let pRegion = MKCoordinateRegion(center: pLocation, span: spanValue) // 위 두 객체 정보를 사용해 내가 봐야 할 위치 정보 설정
        myMap.setRegion(pRegion, animated: true) // 화면 지도 상에 지역 설정하고, 효과를 주는 매개변수 설정
        
        return pLocation // 추가
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) { // locations: 위치 정보가 업데이트 될 때마다 호출됨. 최신의 위치 정보로 goLocation 호출 -> 지도가 움직여
        let pLocation = locations.last // 전달 받은 locations의 위치 정보. 가장 마지막 정보(못 받았을 경우) or 갱신받은 정보
        _ = goLocation(latitudeValue: (pLocation?.coordinate.latitude)!, longitudeValue: (pLocation?.coordinate.longitude)!, delta: 0.01)
        
        // 역 지오코딩
        CLGeocoder().reverseGeocodeLocation(pLocation!, completionHandler: { // 위도 경도 -> 주소 (원하는 정보)로 수행하는 과정 : 서버에 물어보는 것이라 네트워크가 되어야 함.
            (placemarks, error) -> Void in
            let pm = placemarks!.first // placemarks가 여러 개 있을 수 있음. 여러 사무실이 동일한 주소일 수 있는데, 지금은 테스트라 첫 번재 사용
            let country = pm!.country
            var address: String = country!
            
            if pm!.locality != nil {
                address += " "
                address += pm!.locality!
            }
            
            if pm!.thoroughfare != nil {
                address += " "
                address += pm!.thoroughfare!
            }
            
            self.lblLocationInfo1.text = "현재 위치"
            self.lblLocationInfo2.text = address
        })
        
        locationManager.stopUpdatingLocation()
    }
    
    // 핀 설정 함수
    func setAnnotation(latitudeValue: CLLocationDegrees, longitudeValue: CLLocationDegrees, delta span: Double, title strTitle: String, subtitle strSubtitle: String) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = goLocation(latitudeValue: latitudeValue, longitudeValue: longitudeValue, delta: span)
        
        annotation.title = strTitle
        annotation.subtitle = strSubtitle
        myMap.addAnnotation(annotation)
    }
    
    @IBAction func sgChangeLocation(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            locationManager.startUpdatingLocation()
        } else if sender.selectedSegmentIndex == 1 {
            setAnnotation(latitudeValue: 37.406840, longitudeValue: 127.117437, delta: 0.1, title: "봇들마을 이지더원 아파트", subtitle: "경기도 성남시 분당구 삼평동 판교로 393")
            self.lblLocationInfo1.text = "보고 계신 위치"
            self.lblLocationInfo2.text = "봇들마을 이지더원 아파트"
        } else if sender.selectedSegmentIndex == 2 {
            setAnnotation(latitudeValue: 37.556876, longitudeValue: 126.914066, delta: 1, title: "이지스퍼블리싱", subtitle: "서울시 마보구 잔다리로 109 이지스 빌딩")
            self.lblLocationInfo1.text = "보고 계신 위치"
            self.lblLocationInfo2.text = "이지스퍼블리싱 출판사"
        }
    }
}

