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
    
    @IBOutlet var lblCurrentTime: UILabel!
    @IBOutlet var lblPickerTime: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        Timer.scheduledTimer(timeInterval: interval, target: self, selector: timeSelector, userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: alarmInterval, target: self, selector: alarmSelector, userInfo: nil, repeats: false)
        
    }

    @IBAction func changeDatePicker(_ sender: UIDatePicker) {
        let datePickerView = sender
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm EEE"
        lblPickerTime.text = "선택시간: " + formatter.string(from: datePickerView.date)
        
        pick = formatter.string(from: datePickerView.date)
    
    }
    
    @objc func updateTime() {
//        lblCurrentTime.text = String(count)
//        count = count + 1
        
        let date = NSDate()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm EEE"
        lblCurrentTime.text = "현재시간: " + formatter.string(from: date as Date)
        
        let cur = formatter.string(from: NSDate() as Date)
        if (pick == cur) {
            view.backgroundColor = UIColor.red
        }
        
        // 시간 맞으면 빨갛게 변하긴 하는데 안 돌아옴
    }
}

