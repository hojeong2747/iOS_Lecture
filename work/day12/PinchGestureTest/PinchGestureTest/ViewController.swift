//
//  ViewController.swift
//  PinchGestureTest
//
//  Created by Dongduk1 on 2023/07/07.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var imgPinch: UIImageView!
    
    var initialFontSize:CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(ViewController.doPinch(_:)))
        self.view.addGestureRecognizer(pinch)
    }
    
    @objc func doPinch(_ pinch: UIPinchGestureRecognizer) { // UIGestureRecognizer 상속받은 타입
//        if (pinch.state == UIGestureRecognizer.State.began) {
//            initialFontSize = txtPinch.font.pointSize // 처음 값을 기준 값으로 둠
//        } else {
//            txtPinch.font = txtPinch.font.withSize(initialFontSize * pinch.scale)
//        }
//        // pinch -> state, scale 정보 사용
        
        imgPinch.transform = imgPinch.transform.scaledBy(x: pinch.scale, y: pinch.scale)
        pinch.scale = 1
    }

    

}

