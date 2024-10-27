//
//  ChatInputAccesoryView.swift
//  GotoKusakariAPP
//
//  Created by madoka suzuki on 2023/02/28.
//

import UIKit
protocol ChatInputAccesoryViewDelegate{
    func tappedsendbutton(text:String)
}
class ChatInputAccesoryView: UIView,UITextViewDelegate {
    
    
    @IBOutlet var chattextview:UITextView!
    @IBOutlet var sendbutton:UIButton!
    var delegate:ChatInputAccesoryViewDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        nibinit()
       setupviews()
     // autoresizingMask = .flexibleHeight
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override var intrinsicContentSize: CGSize{
        return .zero
    }
    func nibinit(){
        let nib = UINib(nibName: "ChatInputAccesoryView", bundle: nil)
        // 存在したら読み込む・存在しなかったら読み込まない
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(view)
    }
    func setupviews(){
        chattextview.layer.cornerRadius = 15
        chattextview.layer.borderColor = UIColor(cgColor: CGColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)).cgColor
        chattextview.layer.borderWidth = 1
        sendbutton.imageView?.contentMode = .scaleAspectFill
        sendbutton.contentHorizontalAlignment = .fill
        sendbutton.contentVerticalAlignment = .fill
        //最初、文字が入ってない状態で送信ボタンを押せないようにする
        sendbutton.isEnabled = false
        //初期画面に文字が入ってない
        chattextview.text = ""
        chattextview.delegate = self
        
    }
    //文字が入ったら送信ボタンが押せる
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty{
            sendbutton.isEnabled = false
        }else{
            sendbutton.isEnabled = true
        }
    }
    @IBAction func tapped(){
        guard let text = chattextview.text else { return }
        delegate?.tappedsendbutton(text: text)
    }
    func removetext(){
        chattextview.text = ""
        sendbutton.isEnabled = false
    }
    
}
