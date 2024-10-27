//
//  ChatRoomTableViewCell.swift
//  GotoKusakariAPP
//
//  Created by madoka suzuki on 2023/02/13.
//

import UIKit
import Firebase
class ChatRoomTableViewCell: UITableViewCell {
    @IBOutlet var userimageview: UIImageView!
    @IBOutlet var partnerchattextview: UITextView!
    @IBOutlet var partnertimelabel: UILabel!
    @IBOutlet var chattextview: UITextView!
    @IBOutlet var timelabel: UILabel!
    
    var messegetext:Message?{
        didSet{
//            guard let text = messegetext?.message else { return }
//            let width = estimateFrameForTextView(text: text).width + 20
//            messegetextviewconstraints.constant = width
//            partnerchattextview.text = text
        }
    }
    @IBOutlet weak var mymessagetextviewconstraints: NSLayoutConstraint!
    @IBOutlet weak var messegetextviewconstraints: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        userimageview.layer.cornerRadius = 25
        chattextview.layer.cornerRadius = 15
        partnerchattextview.layer.cornerRadius = 15
        backgroundColor = .clear
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
checkwithusermassage()
        // Configure the view for the selected state
    }
    func checkwithusermassage(){
        guard let uid = Auth.auth().currentUser?.uid else { return  }
        if uid == messegetext?.uid{
            partnerchattextview.isHidden = true
            partnertimelabel.isHidden = true
            userimageview.isHidden = true
            chattextview.isHidden = false
            timelabel.isHidden = false
            
            if let messegetext = messegetext {
                chattextview.text = messegetext.message
                timelabel.text = dateformatter(date: messegetext.createdAtTime.dateValue())
                let width = estimateFrameForTextView(text: messegetext.message).width + 20
                mymessagetextviewconstraints.constant = width
            }
        }else{
            partnerchattextview.isHidden = false
            partnertimelabel.isHidden = false
            userimageview.isHidden = false
            chattextview.isHidden = true
            timelabel.isHidden = true
            //ユーザーイメージを後で書く20230523
            if let messegetext = messegetext {
                partnerchattextview.text = messegetext.message
                partnertimelabel.text = dateformatter(date: messegetext.createdAtTime.dateValue())
                let width = estimateFrameForTextView(text: messegetext.message).width + 20
                messegetextviewconstraints.constant = width
            }
        }
    }
    func estimateFrameForTextView(text: String)-> CGRect{
        let size = CGSize(width: 200, height: 1000)
        let options =
        NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        //return NSString(string: text).boundingRect(with: size, options:options, context: nil)
        
        return NSString(string: text).boundingRect(with: size, options:options, attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 16)],context: nil)
    }
    func dateformatter(date:Date) -> String{
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from:date)
    }
}
