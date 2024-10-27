//
//  KusakariDateSaveViewController.swift
//  GotoKusakariAPP
//
//  Created by madoka suzuki on 2023/06/09.
//

import UIKit
import Firebase
import PKHUD
class KusakariDateSaveViewController: UIViewController {
    
    @IBOutlet var kusakaridatetextfield:UITextField!
    @IBOutlet var kusakariplacetextfield:UITextField!
    @IBOutlet var kusakaritimetextfield:UITextField!
    @IBOutlet var kusakaritransportation:UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        kusakaridatetextfield.text = UserDefaults.standard.object(forKey: "calendar") as! String
        kusakariplacetextfield.text = UserDefaults.standard.string(forKey: "location")
        kusakaritimetextfield.text = UserDefaults.standard.string(forKey: "time")
        kusakaritransportation .text = UserDefaults.standard.string(forKey: "transportation")
        
        // Do any additional setup after loading the view.
    }
    
    let yyyy = UserDefaults.standard.object(forKey: "yyyy")
    let mm = UserDefaults.standard.object(forKey: "mm")
    let dd = UserDefaults.standard.object(forKey: "dd")
    
    @IBAction func savedbutton(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let docData = [
            "date":UserDefaults.standard.object(forKey: "date"),
            "stringdate":UserDefaults.standard.object(forKey: "calendar"),
            "place":self.kusakariplacetextfield.text!,
            "time":self.kusakaritimetextfield.text!,
            "helptype":UserDefaults.standard.string(forKey: "CLselection"),
            "transportation":self.kusakaritransportation.text!,
            "user": uid
            
        ] as [String : Any]
        UserDefaults.standard.removeObject(forKey: "CLselection")
        Firestore.firestore().collection("Candidate").addDocument(data: docData){(err) in
            if let err = err{
                return
            }
            HUD.flash(.success)
            
            self.navigationController?.popToRootViewController(animated: true)
        }
    }

}


//"\(yyyy)/\(mm)/\(dd)"
