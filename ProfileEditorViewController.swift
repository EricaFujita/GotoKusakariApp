//
//  ProfileEditorViewController.swift
//  GotoKusakariAPP
//
//  Created by madoka suzuki on 2022/11/22.
//

import UIKit
import PKHUD
import Firebase

class ProfileEditorViewController: UIViewController ,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource{
    @IBOutlet var faceimage:UIImageView!
    @IBOutlet var name:UITextField!
    @IBOutlet var cellphone:UITextField!
    @IBOutlet var place:UITextField!
    var pickerview:UIPickerView = UIPickerView()
    var pickerview2:UIPickerView = UIPickerView()
    @IBOutlet var level:UITextField!
    @IBOutlet var button1:UIButton!
    @IBOutlet var button2:UIButton!
    @IBOutlet var button3:UIButton!
   
    var users = [User]()
    var user:User?
    
    var count1:Int=0
    var count2:Int=0
    var count3:Int=0
    
    var urlstring:String?
    
    func loginuserinfo(){
        guard let uid = Auth.auth().currentUser?.uid else { return  }
        Firestore.firestore().collection("users").document(uid).getDocument {snapshot, err in
            if let err = err{
                return
        }
            guard let snapshot = snapshot, let dic = snapshot.data() else {return}
            let user = User(dic: dic)
           self.user = user
            self.name.text = user.username
            self.place.text = user.place
            self.level.text = user.level
            if user.cellphone != nil{
            self.cellphone.text = String(user.cellphone)
            }
            if user.profileImageUrl != nil{
                let url = URL(string: user.profileImageUrl!)
                do{
                    let data = try Data(contentsOf: url!)
                    let image = UIImage(data: data)
        self.faceimage.image = image
                }catch let err{
                    
                }
            }else{
                self.faceimage.image = UIImage(named: "profile.png")
            }
    }
    }
    //奇数回だとチェックが入る、偶数回だとチェックが外れる
    @IBAction func tapbottun1(){
        count1=count1+1
        if count1 % 2 == 1{
                    button1.setImage(UIImage(named: "checkboxgreen.png"), for: .normal)
                    
                }else{
                    button1.setImage(UIImage(named: "checkboxwhite.png"), for: .normal)
                }
    }
    //宿題：ボタン2.3についても同じことをやる
    
    @IBAction func tapbottun2(){
        count2=count2+1
        if count2 % 2 == 1{
            button2.setImage(UIImage(named: "checkboxgreen.png"), for: .normal)
            
        }else{
            button2.setImage(UIImage(named: "checkboxwhite.png"), for: .normal)
        }
    }
    @IBAction func tapbottun3(){
        count3=count3+1
        if count3 % 2 == 1{
            button3.setImage(UIImage(named: "checkboxgreen.png"), for: .normal)
            
        }else{
            button3.setImage(UIImage(named: "checkboxwhite.png"), for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginuserinfo()
        button1.setImage(UIImage(named: "checkboxwhite.png"), for: .normal)
        button2.setImage(UIImage(named: "checkboxwhite.png"), for: .normal)
        button3.setImage(UIImage(named: "checkboxwhite.png"), for: .normal)
        pickerview.delegate=self
        pickerview.dataSource=self
        pickerview.showsSelectionIndicator=true
        pickerview2.delegate=self
        pickerview2.dataSource=self
        pickerview2.showsSelectionIndicator=true
        pickerview.tag=1
        pickerview2.tag=2
        
        let toolbar=UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width,height: 35))
        let spaceitem=UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
       
        let doneitem=UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolbar.setItems([spaceitem, doneitem], animated: true)
       
        let toolbar2=UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width,height: 35))
        let spaceitem2=UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneitem2=UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done2))
        
        toolbar2.setItems([spaceitem2, doneitem2], animated: true)
        
        place.inputView=pickerview
        place.inputAccessoryView=toolbar
        level.inputView=pickerview2
        level.inputAccessoryView=toolbar2
    }
    //画像を選択する時の定型文
    @IBAction func selectimage(_ sender:Any){
        //画像の選択肢を示す
        let actioncontroller = UIAlertController(title: "画像を選択する", message: "選択してください", preferredStyle: .actionSheet)
        //カメラを起動させる
        let cameraaction = UIAlertAction(title: "カメラを起動させる", style: .default){(action)in
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            picker.allowsEditing = true
            self.present(picker, animated: true, completion: nil)
        }
        //アルバムにアクセスする
        let albumaction = UIAlertAction(title:"アルバムを見る", style: .default){(action)in
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            picker.allowsEditing = true
            self.present(picker, animated: true, completion: nil)
        }
        //キャンセルの項目入れる（APPストアの規定だから）
        let cancelaction = UIAlertAction(title: "キャンセルする", style: .cancel){(action)in
            self.dismiss(animated: true, completion: nil)
        }
        //3つの選択肢についてのボタンをつけていく
        actioncontroller.addAction(cameraaction)
        actioncontroller.addAction(albumaction)
        actioncontroller.addAction(cancelaction)
        self.present(actioncontroller, animated: true, completion: nil)
    }
    //選んだ画像を表示させる
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
           let pickerimage = info[.editedImage]as! UIImage
            faceimage.image = pickerimage
            picker.dismiss(animated: true, completion: nil)
            
            let uploadimage = pickerimage.jpegData(compressionQuality: 0.3)
            HUD.show(.progress)
            let filename = NSUUID().uuidString
            let storageref = Storage.storage().reference().child("profile_image").child(filename)
            storageref.putData(uploadimage!, metadata: nil){(metadata,err)in
                if let err = err{
                    HUD.hide()
                    return
                }
                storageref.downloadURL{ [self]url,err in
                    if let err = err{
                        HUD.hide()
                        return
                    }
                   urlstring = url?.absoluteString
                   
            }
        }
    }
    //アルバムまでいっちゃったけどキャンセルする
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)

        }
    let
    listplace:[String]=["福江島","奈留島","久賀島","若松島","中通島","小値賀島","その他の五島列島内の島","五島列島以外"]
        let listlevel:[String]=["生まれて初めてします","過去に数回やったことあります","年に1、2回やります","毎シーズンやります","人に教えられるほどの腕前です"]
    
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
        func creatuserinfo(profileimageurl:String){
            Auth.auth().currentUser!.createProfileChangeRequest().displayName = self.name.text
            Auth.auth().currentUser!.createProfileChangeRequest().commitChanges { err in
                if let err = err{
                    return
                }
                let cellphone = self.cellphone.text ?? ""
                print(self.place.text,"更新チェック")
                let docData = [
                    "username":self.name.text!,
                    "cellphone":cellphone,
                    "place":self.place.text!,
                    "level":self.level.text!,
                    "createdAtTime":Timestamp(),
                    "kusakariki":self.count1,
                    "kuruma":self.count2,
                    "kama":self.count3,
                    "profileImageUrl": profileimageurl
                ] as [String : Any]
                guard let uid = Auth.auth().currentUser?.uid else { return  }
                Firestore.firestore().collection("users").document(uid).setData(docData){(err)in
                    if let err = err{
                        return
                    }
                }
            }
        }
        @IBAction func profilesave(){
            //7.26宿題
            let image = faceimage.image
            if image != nil && image != UIImage(named: "profile.png"){
                creatuserinfo(profileimageurl: urlstring!)
                
            }else{
                Auth.auth().currentUser!.createProfileChangeRequest().displayName = self.name.text
                Auth.auth().currentUser!.createProfileChangeRequest().commitChanges { err in
                    if let err = err{
                        return
                    }
                    let cellphone = self.cellphone.text ?? ""
                    print(self.place.text,"更新チェック")
                    let docData = [
                        "username":self.name.text!,
                        "cellphone":cellphone,
                        "place":self.place.text!,
                        "level":self.level.text!,
                        "createdAtTime":Timestamp(),
                        "kusakariki":self.count1,
                        "kuruma":self.count2,
                        "kama":self.count3
                    ] as [String : Any]
                    guard let uid = Auth.auth().currentUser?.uid else { return  }
                    Firestore.firestore().collection("users").document(uid).setData(docData){(err)in
                        if let err = err{
                            return
                        }
                    }
                }
                
            }
            
            //★6/28ここにPKHUD追加あってる？
                    HUD.flash(.success)
                    //登録がすべて終わってから次のページに移る。途中で移行しない。
            self.navigationController?.popViewController(animated: true)
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
}

