//
//  ViewController.swift
//  MyApp
//
//  Created by cs_mac on 2020/07/22.
//  Copyright © 2020 cs_mac. All rights reserved.
//

import UIKit

class AddViewController: UIViewController {
    @IBOutlet var dpPicker: UIDatePicker!
    @IBOutlet var tfTitle: UITextField!
    @IBOutlet var tfDetail: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // DatePicker 에 현재 시간 설정
        let date = NSDate()
        dpPicker.setDate(date as Date, animated: true)
    }

    @IBAction func btnSave(_ sender: UIButton) {
        // 뷰에 입력한 값을 사용하여 DB에 추가
        manager.insertData(title: tfTitle.text!, date: Int32(dpPicker.date.timeIntervalSince1970), detail: tfDetail.text!, icon: "cart.png")
        tfTitle.text=""
        tfDetail.text=""
        
        _ = navigationController?.popViewController(animated: true)
    }
    

}

