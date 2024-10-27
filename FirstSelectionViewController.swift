//
//  FirstSelectionViewController.swift
//  GotoKusakariAPP
//
//  Created by madoka suzuki on 2023/04/13.
//

import UIKit
import Firebase
class FirstSelectionViewController: UIViewController {
    let ud = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func yellow(){
        ud.set("yellow", forKey: "selection")
            ud.synchronize()
        self.performSegue(withIdentifier: "yellow", sender: nil)
    }
    @IBAction func green(){
        ud.set("green", forKey: "selection")
            ud.synchronize()
        self.performSegue(withIdentifier: "green", sender: nil)
    }

}
