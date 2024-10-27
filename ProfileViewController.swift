//
//  ProfileViewController.swift
//  GotoKusakariAPP
//
//  Created by madoka suzuki on 2022/10/30.
//

import UIKit
import Firebase
import LUExpandableTableView
class ProfileViewController: UIViewController ,UIPickerViewDelegate,UIPickerViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    @IBOutlet var name:UITextField!
    @IBOutlet var email:UITextField!
    @IBOutlet var password:UITextField!
    @IBOutlet var cellphone:UITextField!
    @IBOutlet var place:UITextField!
    var pickerview:UIPickerView = UIPickerView()
    var pickerview2:UIPickerView = UIPickerView()
    
    @IBOutlet var button1:UIButton!
    @IBOutlet var button2:UIButton!
    @IBOutlet var button3:UIButton!
   
    var count1:Int=0
    var count2:Int=0
    var count3:Int=0
    

    @IBAction func tapbottun1(){
        count1=count1+1
        if count1%2==1{
            button1.setImage(UIImage(named: "checkboxgreen.png"), for: .normal)
        }else{
            button1.setImage(UIImage(named: "checkboxwhite.png"), for: .normal)
        }
    }
   
    @IBAction func tapbottun2(){
        count2=count2+1
        if count2%2==1{
            button2.setImage(UIImage(named: "checkboxgreen.png"), for: .normal)
        }else{
            button2.setImage(UIImage(named: "checkboxwhite.png"), for: .normal)
        }
    }
    
    @IBAction func tapbottun3(){
        count3=count3+1
        if count3%2==1{
            button3.setImage(UIImage(named: "checkboxgreen.png"), for: .normal)
        }else{
            button3.setImage(UIImage(named: "checkboxwhite.png"), for: .normal)
        }
    }
 
    let
listplace:[String]=["福江島","奈留島","久賀島","若松島","中通島","小値賀島","その他の五島列島内の島","五島列島以外"]
    @IBOutlet var level:UITextField!
    let listlevel:[String]=["生まれて初めてします","過去に数回やったことあります","年に1、2回やります","毎シーズンやります","人に教えられるほどの腕前です"]
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerview.delegate=self
        pickerview.dataSource=self
        pickerview.showsSelectionIndicator=true
        pickerview2.delegate=self
        pickerview2.dataSource=self
        pickerview2.showsSelectionIndicator=true
        
        pickerview.tag=1
        pickerview2.tag=2
        
        let toolbar1=UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width,height: 35))
        let spaceitem1=UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneitem1=UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        
        let toolbar2=UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width,height: 35))
        let spaceitem2=UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneitem2=UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done2))
        
        toolbar1.setItems([spaceitem1, doneitem1], animated: true)
        toolbar2.setItems([spaceitem2, doneitem2], animated: true)
        place.inputView=pickerview
        place.inputAccessoryView=toolbar1
        level.inputView=pickerview2
        level.inputAccessoryView=toolbar2
    }
    
    @objc func done(){
        place.endEditing(true)
        place.text="\(listplace[pickerview.selectedRow(inComponent: 0)])"
    }
    
    @objc func done2(){
        level.endEditing(true)
        level.text="\(listlevel[pickerview2.selectedRow(inComponent: 0)])"
    }
    @objc(numberOfComponentsInPickerView:) func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
        
    }
    @objc func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView.tag==1){
            return listplace.count
        }else{
            return listlevel.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView.tag==1){
            return listplace[row]
        }else{
            return listlevel[row]
        }
        
    }
    @IBAction func profilesave(){
        if (name.text != "") || (email.text != "") || (password.text != "") ||  (cellphone.text != "") {
            Auth .auth().createUser(withEmail: email.text!, password: password.text!){(res,err)in
                if let err = err{
                    if let errCode = AuthErrorCode.Code(rawValue: err._code)  {
                                        switch errCode {
                                        case .invalidEmail: break
                                        case .emailAlreadyInUse:
                                            let alert = UIAlertController(title: "このメールアドレスはすでに登録されています", message:"", preferredStyle: .alert)
                                            let okaction = UIAlertAction(title: "OK", style: .default){(action)in
                                                alert.dismiss(animated: true, completion: nil)
                                            }
                                            alert.addAction(okaction)
                                            self.present(alert, animated:true, completion: nil)
                                            
                                        
                                        case .weakPassword:
                                            let alert = UIAlertController(title: "パスワードは6文字以上で設定してください", message:"", preferredStyle: .alert)
                                            let okaction = UIAlertAction(title: "OK", style: .default){(action)in
                                                alert.dismiss(animated: true, completion: nil)
                                            }
                                            alert.addAction(okaction)
                                            self.present(alert, animated: true, completion: nil)
                                        default: break
                                            
                                        }
                    }
                }
                guard let uid = res?.user.uid else {return}
                guard let username = self.name.text else {return}
                if self.count1 % 2 == 1{
                    self.count1 = 1
                }else{
                    self.count1 = 0
                }
                if self.count2 % 2 == 1{
                    self.count2 = 1
                }else{
                    self.count2 = 0
                }
                if self.count3 % 2 == 1{
                    self.count3 = 1
                }else{
                    self.count3 = 0
                }
                let docData = [
                    "email":self.email.text!,
                    "username":self.name.text!,
                    "cellphone":self.cellphone.text!,
                    "place":self.place.text!,
                    "level":self.level.text!,
                    "createdAtTime":Timestamp(),
                    "kusakariki":self.count1,
                    "kuruma":self.count2,
                    "kama":self.count3,
                    "selection":UserDefaults.standard.string(forKey: "selection")
                ] as [String : Any]
                Firestore.firestore().collection("users").document(uid).setData(docData){(err)in
                    if let err = err{
                        return
                    }
                    let ud = UserDefaults.standard
                    ud.set(true, forKey: "islogin")
                        //端末にアイパスを保存する
                        ud.set(self.email.text!, forKey: "userid")
                        ud.set(self.password.text!, forKey: "userpassword")

                        //「同じ端末を使ってる限り消えないよ」
                            ud.synchronize()
                    //firebaseに保存された後uidを削除するよ
                    UserDefaults.standard.removeObject(forKey: "selection")
                    self.performSegue(withIdentifier: "torule", sender: nil)
                    
                }
            }
    
           
        }else if name.text == ""{
                let alert = UIAlertController(title: "名前を入力してください", message:"", preferredStyle: .alert)
                let okaction = UIAlertAction(title: "OK", style: .default){(action)in
                    alert.dismiss(animated: true, completion: nil)
                }
                //左に表示したいものを先に書く
                alert.addAction(okaction)
                self.present(alert, animated: true, completion: nil)
            
            }else if email.text == ""{
                let alert = UIAlertController(title: "メールアドレスを入力してください", message:"", preferredStyle: .alert)
                let okaction = UIAlertAction(title: "OK", style: .default){(action)in
                    alert.dismiss(animated: true, completion: nil)
                }
               
                //左に表示したいものを先に書く
                alert.addAction(okaction)
                self.present(alert, animated: true, completion: nil)
           
                
        }else if password.text == ""{
                let alert = UIAlertController(title: "パスワードを入力してください", message:"", preferredStyle: .alert)
                let okaction = UIAlertAction(title: "OK", style: .default){(action)in
                    alert.dismiss(animated: true, completion: nil)
                }
                
                //左に表示したいものを先に書く
                alert.addAction(okaction)
                self.present(alert, animated: true, completion: nil)
            
        }else if cellphone.text == ""{
            
                let alert = UIAlertController(title: "携帯番号を入力してください", message:"", preferredStyle: .alert)
                let okaction = UIAlertAction(title: "OK", style: .default){(action)in
                    alert.dismiss(animated: true, completion: nil)
                }
                //左に表示したいものを先に書く
                alert.addAction(okaction)
                self.present(alert, animated: true, completion: nil)
        }
       
        
    }
    
}
