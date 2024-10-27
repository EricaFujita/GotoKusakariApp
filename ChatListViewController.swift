//
//  ChatListViewController.swift
//  GotoKusakariAPP
//
//  Created by madoka suzuki on 2023/02/08.
//

import UIKit
import Firebase
class ChatListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var users = [User]()
    var chatrooms = [ChatRoom]()
    var chatroomlistener: ListenerRegistration?
    var user:User?{
        didSet{
            navigationItem.title = user?.username
        }
    }
    @IBOutlet var chatListTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        chatListTableView.delegate = self
        chatListTableView.dataSource = self
        chatListTableView.tableFooterView = UIView()
        //ヘッダーの色を変えるコード
        navigationController?.navigationBar.barTintColor = UIColor(cgColor: CGColor(red: 39/255, green: 49/255, blue: 69/255, alpha: 1))
        //タイトルの設定
        navigationItem.title = "トーク一覧"
        //ダークモードにしても文字が見えるようにする設定（とりあえず白設定）
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor:UIColor.white]
       confirmlogedinuser()
        //loginuserinfo()
        //chatRoomInfoFromFirestore()
        
    }
    //毎回呼び込まれるようにするコード
    override func viewWillAppear(_ animated: Bool) {
        userfromfirestore()
        chatRoomInfoFromFirestore()
        loginuserinfo()
    }
    func userfromfirestore(){
        self.users = [User]()
        Firestore.firestore().collection("users").getDocuments { snapshot, err in
            if let err = err{
                return
            }
            snapshot?.documents.forEach({ snapshot in
                let dic = snapshot.data()
                let user = User.init(dic: dic)
                self.users.append(user)
                self.chatListTableView.reloadData()
            })
        }
    }
    func loginuserinfo(){
        guard let uid = Auth.auth().currentUser?.uid else { return  }
        Firestore.firestore().collection("users").document(uid).getDocument {snapshot, err in
            if let err = err{
                return
        }
            guard let snapshot = snapshot, let dic = snapshot.data() else {return}
            let user = User(dic: dic)
           self.user = user
    }
    }
    func chatRoomInfoFromFirestore(){
        chatroomlistener?.remove()
        chatrooms.removeAll()
        chatListTableView.reloadData()
        Firestore.firestore().collection("chatRooms").addSnapshotListener { snapshots, err in
            if let err = err{
                return
            }
            snapshots?.documentChanges.forEach({ documentchange in
                switch documentchange.type{
                case .added:
                    let dic = documentchange.document.data()
                    let chatroom = ChatRoom(dic: dic)
                    chatroom.documentid = documentchange.document.documentID
                    guard let uid = Auth.auth().currentUser?.uid else { return  }
                    let iscontain = chatroom.members.contains(uid)
                    if !iscontain {return}
                    chatroom.members.forEach { memberuid in
                        if memberuid != uid{
                            Firestore.firestore().collection("users").document(memberuid).getDocument { snapshot, err in
                                if let err = err{
                                    return
                                }
                                guard let dic = snapshot?.data() else { return  }
                                let user = User(dic: dic)
                                user.uid = documentchange.document.documentID
                                chatroom.partneruser = user
                                
                                guard let chatRoomid = chatroom.documentid else {return}
                                let lastmessage = chatroom.lastmessageid
                                if lastmessage == ""{
                                    self.chatrooms.append(chatroom)
                                    self.chatListTableView.reloadData()
                                    return}
                                        Firestore.firestore().collection("chatRooms").document(chatRoomid).collection("messages").document(lastmessage).getDocument{snapshot, err in
                                            if let err = err{
                                                return
                                            
                                        }
                                        guard let data = snapshot?.data()else{return}
                                        let message = Message(dic: data)
                                        chatroom.lastmessage = message
                                        self.chatrooms.append(chatroom)
                                        self.chatListTableView.reloadData()
                                    }
                            }
                        }
                    }
                case .modified:
                    print("nil")
                case .removed:
                    print("nil")
                }
            })
        }
    }
    var window:UIWindow?
    func confirmlogedinuser(){
        print(Auth.auth().currentUser?.uid,"チャットリストのユーザー")
        if Auth.auth().currentUser?.uid == nil{
            let storyboard1=UIStoryboard(name: "Storyboardsignin", bundle:Bundle.main)
            //let signupviewcontroller = storyboard1.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
         let rootviewcotroller1=storyboard1.instantiateViewController(identifier: "RootNavigationController")
            UIApplication.shared.keyWindow?.rootViewController = rootviewcotroller1
           // self.window?.backgroundColor=UIColor.white
            //self.window?.makeKeyAndVisible()
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(chatrooms.count, "カウント")
        if self.chatrooms.count == 0{
            var imageView = UIImageView(frame: CGRectMake(0, 0, self.chatListTableView.frame.width, self.chatListTableView.frame.height))
            // read image
            let image = UIImage(named: "shoki.png")
            // set image to ImageView
            imageView.image = image
            // set alpha value of imageView
            imageView.alpha = 0.5
            // set imageView to backgroundView of TableView
            self.chatListTableView.backgroundView = imageView
        }
        
        return chatrooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let userimageview = cell.viewWithTag(1) as! UIImageView
        let namelabel = cell.viewWithTag(2) as! UILabel
        let lastmessagelabel = cell.viewWithTag(3) as! UILabel
        
        let datelabel = cell.viewWithTag(4) as! UILabel
        
        // cellの背景を透過
        cell.backgroundColor = UIColor.clear
         // cell内のcontentViewの背景を透過
        cell.contentView.backgroundColor = UIColor.clear
        
        //画像の角をとって丸くするThread 2
        userimageview.layer.cornerRadius = 25
        var chatroom:ChatRoom?{
            didSet{
                if let chatroom = chatroom {
                    namelabel.text = chatroom.partneruser?.username
                    lastmessagelabel.text = chatroom.lastmessage?.message
                    print(chatroom.lastmessage?.message,"最後のメッセージ")
                    datelabel.text = dateformatter(date: chatroom.lastmessage?.createdAtTime.dateValue() ?? Date())
                    
                    if chatroom.partneruser?.profileImageUrl != nil{
                        let url = URL(string: (chatroom.partneruser?.profileImageUrl)!)
                        do{
                            let data = try Data(contentsOf: url!)
                            let image = UIImage(data: data)
                userimageview.image = image
                        }catch let err{
                            
                        }
                    }else{
                        userimageview.image = UIImage(named: "profile.png")
                    }
                }
            }
        }
        chatroom = chatrooms[indexPath.row]
        //user = users[indexPath.row]
        return cell
    }
    //セルの高さを制限
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
        
    }
    //画面遷移
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatroomviewcontroller = storyboard?.instantiateViewController(withIdentifier: "ChatRoomViewController")as! ChatRoomViewController
        chatroomviewcontroller.user = user
        chatroomviewcontroller.chatroom = chatrooms[indexPath.row]
        navigationController?.pushViewController(chatroomviewcontroller, animated: true)
    }
    func dateformatter(date:Date) -> String{
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from:date)
    }
}
