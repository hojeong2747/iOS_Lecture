//
//  AddViewController.swift
//  TableViewTest
//
//  Created by Dongduk1 on 2023/06/30.
//

import UIKit

class AddViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet var tfAddItem: UITextField!
    
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var pickerImg: UIPickerView!
    
    let MAX_ARRAY_SUM = 3
    let PICKER_VIEW_COLUMN = 1
    let PICKER_VIEW_HEIGHT:CGFloat = 30
    var imageArray = [UIImage?]() // 빈 배열 생성 후 뷰 보여지고 나서 동작에 사용
    var pickedImg = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        for i in 0 ..< MAX_ARRAY_SUM {
            let image = UIImage(named: itemsImageFile[i])
            imageArray.append(image)
        }
        imgView.image = imageArray[0]
    }
    
    @IBAction func btnAddItem(_ sender: UIButton) {
        items.append(tfAddItem.text!)
        itemsImageFile.append(pickedImg)
        tfAddItem.text=""
        _ = navigationController?.popViewController(animated: true)
    }
    
    // 스크롤 되는 게 두 개가 될 수 있다. 몇 칸 표시할 건지 (한 칸으로만 표시)
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return PICKER_VIEW_COLUMN
    }
    
    // 배열 개수 반환. 스크롤 옵션 몇 개로 할 건지 (배열 개수만큼 스크롤 옵션)
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return itemsImageFile.count
    }
    
    // 피커 뷰 룰렛에 파일명 대신 이미지 출력하기, frame은 크기를 줄이는 것
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        // 피커뷰에는 이미지뷰가 없는 상태라서 이미지뷰 액자를 하나 생성해서, 액자 사이즈를(frame) 바꿈
        let imageView = UIImageView(image:imageArray[row])
        imageView.frame = CGRect(x: 0, y:0, width: 50, height: 80)
        
        return imageView
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return PICKER_VIEW_HEIGHT
    }

    // 별도 추가, 스크롤 이벤트 발생했을 때 호출되는 함수, 딱 멈추면 그 위치에 그림 파일 이름을 가져다가 레이블에 표시
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        imgView.image = imageArray[row]
        pickedImg = itemsImageFile[row]
        
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
