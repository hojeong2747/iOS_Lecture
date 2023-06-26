//
//  ViewController.swift
//  DatePickerTest
//
//  Created by Dongduk1 on 2023/06/23.
//

import UIKit

class ViewController: UIViewController {
    let timeSelector: Selector = #selector(ViewController.updateTime)
    let interval = 1.0
    var count = 0
    
    let alarmSelector: Selector = #selector(ViewController.updateTime)
    let alarmInterval = 60.0
    var pick: String = ""
    
    var alaramTime: String = ""
    
    @IBOutlet var lblCurrentTime: UILabel!
    @IBOutlet var lblPickerTime: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        Timer.scheduledTimer(timeInterval: interval, target: self, selector: timeSelector, userInfo: nil, repeats: true)
//        Timer.scheduledTimer(timeInterval: alarmInterval, target: self, selector: alarmSelector, userInfo: nil, repeats: false)
        
    }

    @IBAction func changeDatePicker(_ sender: UIDatePicker) {
        let datePickerView = sender
        
        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd HH:mm:SS EEE"
        formatter.dateFormat = "hh:mm aaa"
        alaramTime = formatter.string(from: datePickerView.date)
        
        lblPickerTime.text = "선택시간: " + formatter.string(from: datePickerView.date)
        
        pick = formatter.string(from: datePickerView.date)
    }
    
    @objc func updateTime() {
//        lblCurrentTime.text = String(count)
//        count = count + 1
        
        let date = NSDate()
        
        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd HH:mm:SS EEE"
        formatter.dateFormat = "hh:mm aaa"
        let currentTime = formatter.string(from: date as Date)
        if (alaramTime == currentTime) {
            let onAlert = UIAlertController(title: "알림", message: "설정한 시간입니다", preferredStyle: UIAlertController.Style.alert)
            let onAction = UIAlertAction(title: "네, 알겠습니다", style: UIAlertAction.Style.default, handler: nil) // alert 작동은 하는데, 네 누르면 1분 동안 알림 창 안 타나게 설정 해야함.
            onAlert.addAction(onAction)
            present(onAlert, animated: true, completion: nil)
        }
        
        lblCurrentTime.text = "현재시간: " + formatter.string(from: date as Date)
        
//        let cur = formatter.string(from: NSDate() as Date)
//        if (pick == cur) {
//            view.backgroundColor = UIColor.red
//        }
        // 시간 맞으면 빨갛게 변하긴 하는데 안 돌아옴
        
    }
}

