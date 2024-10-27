//
//  CandidateListViewController.swift
//  GotoKusakariAPP
//
//  Created by madoka suzuki on 2023/06/09.
//

import UIKit
import Firebase
class CandidateListViewController: UIViewController {
    
//    @IBOutlet var CLtableview: UITableView!
//    var candidates = [Candidate]()
//    var user:User?
    override func viewDidLoad() {
        super.viewDidLoad()
        //テーブルビューに表示させるときに必ず以下の2行を書く
//        CLtableview.delegate = self
//        CLtableview.dataSource = self
//        CLtableview.rowHeight = 100
        // Do any additional setup after loading the view.
    }
    //画面が切り替わるごとに、テーブルビューの情報が更新される
//    override func viewWillAppear(_ animated: Bool) {
//        infofromfirestore()
//    }
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        //次回変更する
//        print(candidates.count,"カウント")
//        return candidates.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "CLcell")!
//        let GYlabel = cell.viewWithTag(1)as! UILabel
//        let namelabel = cell.viewWithTag(2)as! UILabel
//        let datelabel = cell.viewWithTag(3)as! UILabel
//        let uid = candidates[indexPath.row].user
//        print(candidates[indexPath.row].helptype,"ヘルプタイプ")
//
//        if candidates[indexPath.row].helptype == "yellow"{
//            GYlabel.backgroundColor = UIColor.init(red: 255/255, green: 194/255, blue: 50/255, alpha: 1)
//            GYlabel .text = "手伝いたい"
//            GYlabel.textColor = UIColor.white
//        }else{
//            GYlabel.backgroundColor = UIColor.init(red: 0/255, green: 169/255, blue: 96/255, alpha: 1)
//            GYlabel .text = "手伝ってほしい"
//            GYlabel.textColor = UIColor.white
//        }
//
//        //datelabel.text = dateformatter(date: candidates[indexPath.row].date)
//        print(candidates[indexPath.row].stringdate,"日付3")
//        datelabel.text = candidates[indexPath.row].stringdate
//        Firestore.firestore().collection("users").document(uid).getDocument { [self]snapshot, err in
//            if let err = err{
//                return
//        }
//            print(self.user,"ユーザー")
//            self.user = User(dic: (snapshot?.data())!)
//            namelabel.text = self.user?.username
//        }
//
//        //同じセルを複製する
//        return cell
//    }
//    func dateformatter(date:Date) -> String{
//        let formatter = DateFormatter()
//        formatter.dateStyle = .short
//        formatter.timeStyle = .short
//        formatter.locale = Locale(identifier: "ja_JP")
//        return formatter.string(from:date)
//    }
    let ud = UserDefaults.standard
    @IBAction func yellow(){
        ud.set("yellow", forKey: "CLselection")
            ud.synchronize()
    }
    @IBAction func green(){
        ud.set("green", forKey: "CLselection")
            ud.synchronize()
        
    }
//    func infofromfirestore()  {
//        Firestore.firestore().collection("Candidate").getDocuments {snapshots, err in
//            if let err = err{
//                return
//        }
//            snapshots?.documents.forEach({snapshot in
//                let dic = snapshot.data()
//                let info = Candidate.init(dic:dic)
//                //格納したものを表示させていく
//                self.candidates.append(info)
//                print(self.candidates[0].stringdate,"日時2")
//                //テーブルビューをリロードする
//                self.CLtableview.reloadData()
//            }
//            )
//    }
//    }
}

