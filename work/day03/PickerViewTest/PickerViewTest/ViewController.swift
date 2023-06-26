//
//  ViewController.swift
//  PickerViewTest
//
//  Created by Dongduk1 on 2023/06/26.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let MAX_ARRAY_SUM = 10
    let PICKER_VIEW_COLUMN = 2
    let PICKER_VIEW_HEIGHT:CGFloat = 80
    var imageArray = [UIImage?]() // 빈 배열 생성 후 뷰 보여지고 나서 동작에 사용
    var imageFileName = ["1.jpg", "2.jpg", "3.jpg", "4.jpg", "5.jpg",
                         "6.jpg", "7.jpg", "8.jpg", "9.jpg", "10.jpg"]
    
    @IBOutlet var pickerImage: UIPickerView!
    @IBOutlet var lblImageFileName: UILabel!
    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // 10개 이미지를 그림 배열에 추가
        for i in 0 ..< MAX_ARRAY_SUM {
            let image = UIImage(named: imageFileName[i])
            imageArray.append(image)
        }
        
        lblImageFileName.text = imageFileName[0]
        imageView.image = imageArray[0]
    }

    // 스크롤 되는 게 두 개가 될 수 있다. 몇 칸 표시할 건지 (한 칸으로만 표시)
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return PICKER_VIEW_COLUMN
    }
    
    // 배열 개수 반환. 스크롤 옵션 몇 개로 할 건지 (배열 개수만큼 스크롤 옵션)
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return imageFileName.count
    }
    
    // 별도 추가, 배열 요소 값 표시 - row는 몇 번째인지 들어옴. 피커뷰 인덱스 = 배열 인덱스
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return imageFileName[row]
//    }
    
    // 피커 뷰 룰렛에 파일명 대신 이미지 출력하기, frame은 크기를 줄이는 것
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        // 피커뷰에는 이미지뷰가 없는 상태라서 이미지뷰 액자를 하나 생성해서, 액자 사이즈를(frame) 바꿈
        let imageView = UIImageView(image:imageArray[row])
        imageView.frame = CGRect(x: 0, y:0, width: 100, height: 150)
        
        return imageView
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return PICKER_VIEW_HEIGHT
    }
    
    // 별도 추가, 스크롤 이벤트 발생했을 때 호출되는 함수, 딱 멈추면 그 위치에 그림 파일 이름을 가져다가 레이블에 표시
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        // 멀티 컴포넌트 값 구별
        if (component == 0) {
            lblImageFileName.text = imageFileName[row]
        } else {
            // 그림 파일 로딩 작업도 여기서 수행
            imageView.image = imageArray[row]
        }
        
    }


}

