//
//  ViewController.swift
//  sampleAssetURL
//
//  Created by Eriko Ichinohe on 2016/06/08.
//  Copyright © 2016年 Eriko Ichinohe. All rights reserved.
//

import UIKit
import Photos
import MobileCoreServices


class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var displayImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func save(sender: UIButton) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {    //追記
            //写真ライブラリ(カメラロール)表示用のViewControllerを宣言
            let controller = UIImagePickerController()
            
            controller.delegate = self
            //新しく宣言したViewControllerでカメラとカメラロールのどちらを表示するかを指定
            controller.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            //トリミング
            controller.allowsEditing = true
            //新たに追加したカメラロール表示ViewControllerをpresentViewControllerにする
            self.presentViewController(controller, animated: true, completion: nil)
            
        }
        
    }
    
    @IBAction func saveMovie(sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            
            let picker = UIImagePickerController()
            picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            picker.mediaTypes = [kUTTypeMovie as String]
            picker.allowsEditing = false
            picker.delegate = self
            picker.videoQuality = UIImagePickerControllerQualityType.TypeHigh
            
            self.presentViewController(picker, animated: true, completion: nil)
        }
    }
    
    @IBAction func display(sender: UIButton) {
        
        //UserDefaultから取り出す
        // ユーザーデフォルトを用意する
        var myDefault = NSUserDefaults.standardUserDefaults()
        
        // データを取り出す
        var strURL = myDefault.stringForKey("selectedPhotoURL")

        if strURL != nil{
            
            var url = NSURL(string: strURL as! String!)
            let fetchResult: PHFetchResult = PHAsset.fetchAssetsWithALAssetURLs([url!], options: nil)
            let asset: PHAsset = fetchResult.firstObject as! PHAsset
            let manager: PHImageManager = PHImageManager()
            manager.requestImageForAsset(asset,targetSize: CGSizeMake(5, 500),contentMode: .AspectFill,options: nil) { (image, info) -> Void in
                self.displayImageView.image = image
            }
        
        }
    }
    
    
    //カメラロールで写真を選んだ後
    func imagePickerController(imagePicker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        

        let assetURL:AnyObject = info[UIImagePickerControllerReferenceURL]!
        
        var strURL:String = assetURL.description
        
        print(strURL)
        
        
        // ユーザーデフォルトを用意する
        var myDefault = NSUserDefaults.standardUserDefaults()
        
        // データを書き込んで
        myDefault.setObject(strURL, forKey: "selectedPhotoURL")

        // 即反映させる
        myDefault.synchronize()
        
        
        
        //閉じる処理
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

