//
//  ViewController.swift
//  NavigationControlTest
//
//  Created by Dongduk1 on 2023/06/29.
//

import UIKit

class ViewController: UIViewController, EditDelegate {
    
    let imgOn = UIImage(named: "lamp_on.png")
    let imgOff = UIImage(named: "lamp_off.png")
    var isOn = true
    var isZoom = true
    
    @IBOutlet var txtMessage: UITextField!
    @IBOutlet var imgView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        imgView.image = imgOn
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // sender : main, segue : 어디서 왔는지 정보도 들어있음
        // main에서 호출하는 쪽으론 이런 식으로 정보를 보낼 수 있음
        
        let editViewController = segue.destination as! EditViewController
        if segue.identifier == "editButton" {
            editViewController.textWayValue = "segue : user button"
        } else if segue.identifier == "editBarButton" {
            editViewController.textWayValue = "segue : user Bar button"
        }
        
        editViewController.textMessage = txtMessage.text!
        
        editViewController.delegate = self // self == ViewController, EditDelegate를 상속받은 게 ViewController 이므로 역할 가능
        
        editViewController.controller = self
        
        editViewController.isOn = isOn
        
        if editViewController.isZoom {
            editViewController.btnResize.setTitle("축소", for: .normal)
        } else {
            editViewController.btnResize.setTitle("확대", for: .normal)
        }
        editViewController.isZoom = isZoom
    }
    
    // 누군가 이걸 호출하면 됨
    func didMessageEditDone(_ controller: EditViewController, message: String) {
        txtMessage.text = message
    }
    
    func didImageOnOffDone(_ controller: EditViewController, isOn: Bool) {
        if isOn {
            imgView.image = imgOn
            self.isOn = true
        } else {
            imgView.image = imgOff
            self.isOn = false
        }
    }
    
    func didResizeImage(_ controller: EditViewController, isZoom: Bool) {
        let scale: CGFloat = 2.0
        var newWidth: CGFloat, newHeight: CGFloat
        
        if isZoom {
            newWidth = imgView.frame.width / scale
            newHeight = imgView.frame.height / scale
        } else {
            newWidth = imgView.frame.width * scale
            newHeight = imgView.frame.height * scale
        }
        
        imgView.frame.size = CGSize(width: newWidth, height: newHeight)
    }
    

}

