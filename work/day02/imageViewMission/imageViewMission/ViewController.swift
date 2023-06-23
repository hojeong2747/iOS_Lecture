//
//  ViewController.swift
//  imageViewMission
//
//  Created by Dongduk1 on 2023/06/23.
//

import UIKit

class ViewController: UIViewController {
    var imgNo : Int = 1
    
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var btnPrev: UIButton!
    @IBOutlet var btnNext: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        var imgName = String(imgNo) + ".png"
        
        
        
        
    }
    
    
    @IBAction func moveToPrev(_ sender: UIButton) {
        
        
    }
    
    @IBAction func moveToNext(_ sender: UIButton) {
        
    }
    
}

