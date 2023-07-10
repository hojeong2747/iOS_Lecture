//
//  AddViewController.swift
//  DBTest
//
//  Created by Dongduk1 on 2023/07/10.
//

import UIKit

class AddViewController: UIViewController {
    
    var manager: DBManager!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        manager = DBManager()
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
