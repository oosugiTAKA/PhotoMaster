//
//  ViewController.swift
//  PhotoMaster
//
//  Created by takafumi oosugi on 2016/02/12.
//  Copyright © 2016年 myname. All rights reserved.
//

import UIKit
import Social

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    //写真表示用ImageView
    @IBOutlet weak var photoImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    //カメラ、アルバムの呼び出しメソッド
    func precentPickerController(sourceType: UIImagePickerControllerSourceType) {
        //ライブラリの使用できるか判断
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            
            //UIImagePickerControllerをインスタンス化
            let picker = UIImagePickerController()
            
            //ソースタイプを設定
            picker.sourceType = sourceType
            
            //デリゲートを設定
            picker.delegate = self
            self.presentViewController(picker, animated: true, completion: nil)
        }
    }
    
    //写真が選択されたときのメソッド
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo:
        NSDictionary!) {
        self.dismissViewControllerAnimated(true, completion: nil)
            
        //画像出力
        photoImageView.image = image
    }
    
    //画像を取得ボタンを押したときに呼び出されるメソッド
    @IBAction func selectButtonTapped(sender: UIButton) {
        
        //選択肢の上に表示するタイトル、メッセージ、アラートタイプの設定
        let alertController = UIAlertController(title: "画像の取得先を選択", message: nil,preferredStyle: .ActionSheet)
        
        //選択肢の名前と処理を1つずつ設定
        let firstAction = UIAlertAction(title: "カメラ", style: .Default) {
            action in
            self.precentPickerController(.Camera)
        }
        let secondAction = UIAlertAction(title: "アルバム", style: .Default) {
            action in
            self.precentPickerController(.PhotoLibrary)
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .Cancel, handler: nil)
        
        //設定した選択肢をアラートに登録
        alertController.addAction(firstAction)
        alertController.addAction(secondAction)
        alertController.addAction(cancelAction)
        
        //アラートを表示
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    //元の画像にテキスト合成するメソッド
    func drawText(image: UIImage) -> UIImage {
        
        //テキストの内容の設定
        let text = "Life is Tech!"
        
        //グラフィックコンテキスト生成、編集開始
        UIGraphicsBeginImageContext(image.size)
        
        //読み込んだ写真を書き出す
        image.drawInRect(CGRectMake(0, 0, image.size.width, image.size.height))
        
        //描き出す位置と大きさの設定　CGRectMake(x座標、上からのy座標、縦の長さ、横の長さ)
        let textRect = CGRectMake(5, 5, image.size.width - 5, image.size.height - 5)
        
        //textFontAttributes:文字の特性(フォント、カラー、スタイルの設定)
        let textFontAttributes = [
            NSFontAttributeName: UIFont.boldSystemFontOfSize(120),
            NSForegroundColorAttributeName: UIColor.redColor(),
            NSParagraphStyleAttributeName: NSMutableParagraphStyle.defaultParagraphStyle()
        ]
        //textRectで指定した範囲にtextFontAttributesに従ってtextを描く
        text.drawInRect(textRect, withAttributes: textFontAttributes)
        
        //グラフィックコンテキストの画像の取得
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        //グラフィックコンテキストの編集を終了
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    //元の画像にマスク画像を合成するメソッド
    func drawMaskImage(image: UIImage) -> UIImage {
        
        //グラフィックスコンテキスト生成、編集開始
        UIGraphicsBeginImageContext(image.size)
        
        //読み込んだ写真描き出し
        image.drawInRect(CGRectMake(0, 0, image.size.width, image.size.height))
        
        //マスク画像(保存場所：PhotoMaster > Assets.xcassets)
        let maskImage = UIImage(named: "CSC_0856")
        
        //描き出す位置のと大きさの設定
        let offset: CGFloat = 50.0
        let maskRect = CGRectMake(
            image.size.width - maskImage!.size.width - offset,
            image.size.height - maskImage!.size.height - offset,
            maskImage!.size.width,
            maskImage!.size.height
        )
        //maskRetで指定した範囲にmaskImage描きだし
        maskImage!.drawInRect(maskRect)
        
        //グラフィックスコンテキストの画像取得
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        //グラフィックスコンテキストの編集終了
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    //任意のメッセージとOKボタンを持つアラートのメソッド
    func simpleAlert(titleString: String) {
        let alertController = UIAlertController(title: titleString, message: nil, preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    //合成ボタン押した時に呼び出されるメソッド
    @IBAction func processButtonTapped(sender: UIButton) {
        
        //photoImageView.imageがnilでなければselectedPhotoに値が入る
        guard let selectedPhoto = photoImageView.image else {
            
            //nilならアラート表示してメソッドを抜ける
            simpleAlert("画像がありません")
            return
    }
        
        let alertController = UIAlertController(title: "合成するパーツを選択", message: nil, preferredStyle:  .ActionSheet)
        let firstAction = UIAlertAction(title: "テキスト", style: .Default) {
            action in
            
            //selectedPhotoにテキストを合成して画面に描き出す
            self.photoImageView.image = self.drawText(selectedPhoto)
        }
        let secondAction = UIAlertAction(title: "CSC_0856", style: .Default) {
            action in
            
            //selectedPhotoに画像を合成して画面に描き出す
            self.photoImageView.image = self.drawMaskImage(selectedPhoto)
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .Cancel, handler: nil)
        
        alertController.addAction(firstAction)
        alertController.addAction(secondAction)
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true ,completion: nil)
    }
    
    //SNSに投稿するメソッド(FacebookかTwitterのソースタイプが引数)
    func postToSNS(serviceType: String) {
        
        //SLComposeViewControllerのインスタンス化し、serviceTypeを指定
        let myComposeView = SLComposeViewController(forServiceType: serviceType)
        
        //投稿するテキストを指定
        myComposeView.setInitialText("PhotoMasterからの投稿")
        
        //投稿する画像を指定
        myComposeView.addImage(photoImageView.image)
        
        //myComposeViewの画面遷移
        self.presentViewController(myComposeView, animated: true, completion: nil)
    }
    
    //アップロードボタンを押した時に呼ばれるメソッド
    @IBAction func uploadButtonTapped(sender: UIButton) {
        guard let selectedPhoto = photoImageView.image else {
        simpleAlert("画像がありません")
        return
    }
        let alertController = UIAlertController(title: "アップロード先を選択", message: nil, preferredStyle:  .ActionSheet)
        let firstAction = UIAlertAction(title: "Facebookに投稿", style: .Default) {
            action in
            self.postToSNS(SLServiceTypeFacebook)
        }
        let secondAction = UIAlertAction(title: "Twitterに投稿", style: .Default) {
            action in
            self.postToSNS(SLServiceTypeTwitter)
        }
        let thirdAction = UIAlertAction(title: "カメラロールに保存", style: .Default) {
            action in
            UIImageWriteToSavedPhotosAlbum(selectedPhoto, self, nil, nil)
            self.simpleAlert("アルバムに保存されました")
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .Cancel, handler: nil)
        
        alertController.addAction(firstAction)
        alertController.addAction(secondAction)
        alertController.addAction(thirdAction)
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

