//
//  QAViewController.swift
//  GotoKusakariAPP
//
//  Created by madoka suzuki on 2022/12/23.
//

import UIKit
import LUExpandableTableView
class QAViewController: UIViewController, LUExpandableTableViewDataSource, LUExpandableTableViewDelegate{
    
    //折りたたみはストーリーボードを使わずにつくる
    var expandableTableView = LUExpandableTableView()
    let qanumber = ["草刈り初めてでも大丈夫？", "必須アイテムは？", "待ち合わせ場所までの移動は？","ケガをする危険性は？","絶対ダメ！草刈り中NG行為は？"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //テーブルビューの作成
        expandableTableView.frame = view.bounds
        view.addSubview(expandableTableView)
       //セルの作成
        expandableTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        //ヘッダーの作成
        expandableTableView.register(CustumHeader.self, forHeaderFooterViewReuseIdentifier: "CustumHeader")
        expandableTableView.expandableTableViewDelegate = self
        expandableTableView.expandableTableViewDataSource = self
    }
    func numberOfSections(in expandableTableView: LUExpandableTableView) -> Int {
        return qanumber.count
    }
    func expandableTableView(_ expandableTableView: LUExpandableTableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section{
        case 0:
        return 200
        case 1:
        return 200
        case 2:
        return 200
        case 3:
        return 200
        case 4:
        return 500
        default:
        return 50
    }
    }
    func expandableTableView(_ expandableTableView: LUExpandableTableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func expandableTableView(_ expandableTableView: LUExpandableTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = expandableTableView.dequeueReusableCell(withIdentifier: "Cell") else { return UITableViewCell() }
        //セルの中身を書いていく
        cell.textLabel?.numberOfLines=0
        switch indexPath.section{
        case 0:
            cell.textLabel?.text = "もちろん草刈り未経験でも大丈夫です！刈った草を熊手で集めたり、草刈機でやりにくいところを鎌で刈ったり、簡単なことからチャレンジして徐々に覚えていきましょう。わからないことは何でもない地域の人に聞いてみてください。優しく教えてくれるはず。"
       //このあと回答の数だけ↑これをコピペして増やしていく
            case 1:
                cell.textLabel?.text = "草刈りの必須アイテムは、\n❶軍手\n❷ツバの広い帽子\n❸足首まで覆える靴下とスニーカー（あるいは長靴）\n❹長袖・長ズボン\n❺水分（1L以上）\n❻塩分がとれるタブレット類\n❼虫除けスプレー\nの7つです。"
            
           //言葉を分解したらいけるかも？今後余裕があればやる。
            //let attrText = NSMutableAttributedString(string: "❶軍手")
            //attrText.addAttribute(NSAttributedString.Key.font, value:
              //                      UIFont.boldSystemFont(ofSize: 17),range: //NSMakeRange(13, 15))
            //cell.textLabel?.attributedText = attrText
                
                case 2:
                    cell.textLabel?.text = "車の運転ができない人は、チャットで「草刈りを手伝って欲しい人」と相談して移動の仕方を決めてください。福江島は横浜市とほぼ同じ広さ、その他の島も山がちで車以外の手段での移動は困難です。車で送迎してもらう場合はお礼の言葉を忘れずに。"
                    
                    case 3:
                        cell.textLabel?.text = "「草刈り時のNG行為」さえ避ければ大ケガをすることはまずありません。軍手をつける、足は足首まで全部しっかり覆う格好をする、草刈機を使う場合はゴーグルをつけるなどの注意点もケガの防止には重要です。"
            case 4:
                cell.textLabel?.text = "次の4つは絶対に守りましょう。\n死亡事故につながります。\n❶草刈機を使用中の人の半径10m以内には近づかない！\n➡︎まれに割れた歯が飛んで死亡事故につながることがあります。\n❷他人の草刈機を使い回ししない！\n➡︎使い慣れた草刈機を維持・管理をしっかりした上で使用しましょう。\n❸少しでも体調がすぐれない時はやらない！\n➡︎朝起きてすぐの草刈りも体への負担が大きいので避けましょう。\n❹事前に一緒に草刈りをするメンバーで計画を立てましょう。\n➡︎段取りが悪く長時間にわたると、熱中症の危険が高まります。"
    
        //回答の数が合わないときにエラー表示が出ないようにデフォルトは必ず書く
        default:
            cell.textLabel?.text = "回答をお待ちください"
        }
        return cell
    }
    func expandableTableView(_ expandableTableView: LUExpandableTableView, sectionHeaderOfSection section: Int) -> LUExpandableTableViewSectionHeader {
        guard let header = expandableTableView.dequeueReusableHeaderFooterView(withIdentifier: "CustumHeader") as? CustumHeader else { return LUExpandableTableViewSectionHeader() }
        let _ = header.setup(text: qanumber[section])
    return header
    }
    func expandableTableView(_ expandableTableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    func expandableTableView(_ expandableTableView: LUExpandableTableView, heightForHeaderInSection section: Int) -> CGFloat {
        let header = CustumHeader()
        return header.setup(text: qanumber[section])
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
