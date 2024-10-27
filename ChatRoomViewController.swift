//
//  ChatRoomViewController.swift
//  GotoKusakariAPP
//
//  Created by madoka suzuki on 2023/02/13.
//

import UIKit
import Firebase
class ChatRoomViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, ChatInputAccesoryViewDelegate {
    var messeges = [Message]()
    var user:User?
    var chatroom:ChatRoom?
    
    @IBOutlet var chattableview: UITableView!
    lazy var chatInputAccesoryView: ChatInputAccesoryView = {
        let view = ChatInputAccesoryView()
        view.frame = .init(x: 0, y: 0, width: view.frame.width, height: 100)
        view.delegate = self
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        chattableview.delegate = self
        chattableview.dataSource = self
        chattableview.tableFooterView = UIView()
        chattableview.backgroundColor = UIColor(cgColor: CGColor(red: 118/255, green: 140/255, blue: 180/255, alpha: 1))
        let nib = UINib(nibName: "ChatRoomTableViewCell", bundle: nil)
        chattableview.register(nib, forCellReuseIdentifier: "roomcell")
        //チャットテーブルビューを置く場所
        chattableview.contentInset = .init(top: 0, left: 0, bottom: 60, right: 0)
        //インジケーターも底上げする
        chattableview.scrollIndicatorInsets = .init(top: 0, left: 0, bottom: 60, right: 0)
        messagesfromfirestore()
    }
    func messagesfromfirestore(){
        guard let chatroomdocid = chatroom?.documentid else { return }
        Firestore.firestore().collection("chatRooms").document(chatroomdocid).collection("messages").addSnapshotListener { snapshots, err in
            if let err = err{
                return
            }
            snapshots?.documentChanges.forEach({ documentchange in
                switch documentchange.type{
                case .added:
                    let dic = documentchange.document.data()
                    let message = Message(dic: dic)
                    message.partneruser = self.chatroom?.partneruser
                    self.messeges.append(message)
                    self.messeges.sort { m1, m2 in
                        let m1date = m1.createdAtTime.dateValue()
                        let m2date = m2.createdAtTime.dateValue()
                        return m1date < m2date
                        
                    }
                    self.chattableview.reloadData()
                    self.chattableview.scrollToRow(at: IndexPath(row: self.messeges.count - 1, section: 0), at: .bottom, animated: true)
                case .modified:
                    break
                case .removed:
                    break
                }
            })
        }
    }
    override var inputAccessoryView: UIView?{
        get{
            return chatInputAccesoryView
        }
    }
    override var canBecomeFirstResponder: Bool{
        return true
    }
    func tappedsendbutton(text: String) {
        //messeges.append(text)
        //保存したいもの
        guard let name = user?.username else { return }
        print(name,"これは名前")
        guard let chatroomdocid = chatroom?.documentid else { return }
        print(chatroomdocid,"これはID")
        guard let uid = Auth.auth().currentUser?.uid else { return }
        print(uid,"これはUID")
        chatInputAccesoryView.removetext()
        //辞書型
        let docdata = [
            "name":name,
            "createdAtTime":Timestamp(),
            "uid":uid,
            "message":text
        ] as [String : Any]
        let messageid = randomString(length: 20)
        Firestore.firestore().collection("chatRooms").document(chatroomdocid).collection("messages").document(messageid).setData(docdata){(err)in
            if let err = err {
                return
            }
            let lastmessagedata = [
                "lastmessageid":messageid
            ]
            Firestore.firestore().collection("chatRooms").document(chatroomdocid).updateData(lastmessagedata){(err)in
                if let err = err {
                    return
                }
                
            }
            //最新のテーブルビューにする
            //chattableview.reloadData()
        }
    }
        func randomString(length:Int)-> String{
            let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            let len = UInt32(letters.length)
            var randomString = ""
            for _ in 0 ..< length {
                let rand = arc4random_uniform(len)
                var nextChar = letters.character(at: Int(rand))
                randomString += NSString(characters: &nextChar, length: 1) as String
            }
            return randomString
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return messeges.count
            
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "roomcell")as! ChatRoomTableViewCell
            cell.messegetext = messeges[indexPath.row]
            return cell
            
        }
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            chattableview.estimatedRowHeight = 20
            return UITableView.automaticDimension
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
