//
//  EditViewController.swift
//  NavigationControlTest
//
//  Created by Dongduk1 on 2023/06/29.
//

import UIKit

protocol EditDelegate {
    func didMessageEditDone(_ controller: EditViewController, message: String)
    func didImageOnOffDone(_ controller: EditViewController, isOn: Bool)
    func didResizeImage(_ controller: EditViewController, isZoom: Bool)
}

class EditViewController: UIViewController {
    
    var textWayValue : String = ""
    var textMessage : String = ""
    var delegate : EditDelegate? // 실제 가리키는 객체가 아니라, 객체를 가리키는 참조변수
    var controller : ViewController? // ui, delegate 형식으로 다 바라볼 수 있음
    var isOn = false
    var isZoom = false
    
    @IBOutlet var lblWay: UILabel!
    // 수정화면으로 어떠한 방법으로 넘어왔는지 2개 중 1개를 표시하고 싶음
    // -> edti, 수정 버튼 누르면 prepare 함수가 호출되고 화면이 넘어가는 것 -> prepare 함수에 어떤 것에서 넘어왔는지 정보가 제공됨
    
    @IBOutlet var txtMessage: UITextField!
    @IBOutlet var swIsOn: UISwitch!
    @IBOutlet var btnResize: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        lblWay.text = textWayValue
        txtMessage.text = textMessage
        swIsOn.isOn = isOn
    }
    
    @IBAction func btnDone(_ sender: UIButton) {
//        controller?.txtMessage // 이렇게 해보면 ui,delegate 모두 접근 가능 확인됨
        if delegate != nil {
            delegate?.didMessageEditDone(self, message: txtMessage.text!)
            delegate?.didImageOnOffDone(self, isOn: isOn)
            delegate?.didResizeImage(self, isZoom: isZoom)
        }
        
        _ = navigationController?.popViewController(animated: true) // 다시 메인 화면으로 돌아옴
    }
    
    @IBAction func swImageOnOff(_ sender: UISwitch) {
        if sender.isOn {
            isOn = true
        } else {
            isOn = false
        }
    }
    
    @IBAction func resizeImage(_ sender: UIButton) {
        
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
