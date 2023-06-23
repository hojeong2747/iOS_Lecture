//
//  ViewController.swift
//  HelloWorld
//
//  Created by Dongduk1 on 2023/06/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var lblHello: UILabel!
    @IBOutlet var txtName: UITextField!
    @IBOutlet var lblCopy: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    // 버튼 눌렀을 때 동작하는 함수
    @IBAction func btnSend(_ sender: UIButton) {
        lblHello.text = "Hello, " + txtName.text!
    }
    
    @IBAction func btnCopy(_ sender: UIButton) {
        lblCopy.text = lblHello.text
    }
}

