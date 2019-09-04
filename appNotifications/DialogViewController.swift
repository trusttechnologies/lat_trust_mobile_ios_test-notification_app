//
//  DialogViewController.swift
//  appNotifications
//
//  Created by Jesenia Salazar on 9/2/19.
//  Copyright © 2019 Cristian Parra. All rights reserved.
//

import UIKit
import MediaPlayer
import MaterialComponents

class DialogViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var dialogView: UIView!
    
    @IBOutlet weak var persistenceButton: UIButton!
    
    @IBAction func persistenceButton(_ sender: Any) {
        print("Hola")
        self.dismiss(animated: true)
        
    }
    
    @IBOutlet weak var closeButton: UIButton!
    @IBAction func closeButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBOutlet weak var stackView: UIStackView!
    func setBackground(color: backgroundColor){
        switch color {
        case .SOLID:
            view.backgroundColor = UIColor(red:0.17, green:0.16, blue:0.16, alpha:1)
        case .TRANSPARENT:
            view.backgroundColor = UIColor(red:0.17, green:0.16, blue:0.16, alpha:0.6)
        case .NO_BACKGROUND:
            view.backgroundColor = UIColor.clear
        default:
            view.backgroundColor = UIColor(red:0.17, green:0.16, blue:0.16, alpha:0.8)
        }
    }
    
    func fillDialog(content: GenericNotification!) {
        let imageView = UIImageView()
        let body = UILabel()
        if(content.notificationDialog != nil){
            print("soy un dialogo")
            
            //Set the dialog image
            if(verifyUrl(urlString: content.notificationDialog?.imageUrl)){
                let url = NSURL(string: content.notificationDialog!.imageUrl)
                imageView.load(url: url! as URL)
                imageView.frame = CGRect(x: dialogView.center.x - 60, y: 50, width: 120, height: 120)
                dialogView.addSubview(imageView)
            }else{
                imageView.isHidden = true
            }
            
            //Set the close button
            if(!(content.notificationDialog?.isCancelable ?? true)){
                closeButton.isEnabled = false
                closeButton.isHidden = true
            }else{
                closeButton.isEnabled = true
                closeButton.isHidden = false
            }
            
            //Set touching outside the dialog process
            if(!(content.notificationDialog?.isPersistent ?? false)){
                persistenceButton.isEnabled = true
                persistenceButton.isHidden = true
                setBackground(color: .NO_BACKGROUND)
            }else{
                persistenceButton.isEnabled = false
                persistenceButton.isHidden = true
                setBackground(color: .TRANSPARENT)
            }
            
//            let button = MDCButton()
//            button.setupButtonWithType(color: content.notificationDialog?.buttons?[0].color ,type: .whiteButton, mdcType: .text)
//            button.setTitle(content.notificationDialog?.buttons![0].text, for: .normal)
//            button.addTarget(
//                self,
//                action: #selector(onButtonPressed(sender: button, stringUrl: (content.notificationDialog?.buttons![0].action)!)),
//                for: .touchUpInside)
//
//            stackView.addSubview(button)
//            stackView.spacing = 10.0
            
            //Set body label
            body.text = content.notificationDialog?.textBody
            body.textAlignment = NSTextAlignment.center
            body.frame = CGRect(x: 24 , y: imageView.bounds.maxY + 78, width: dialogView.bounds.width - 24, height: 140)
            body.lineBreakMode = .byCharWrapping
            body.numberOfLines = 5
            dialogView.addSubview(body)
            
            print(content.notificationDialog?.buttons)
            
            
            
        }else if(content.notificationVideo != nil){
            print("soy un video")
        }else if(content.notificationBody != nil){
            print("soy una noti normal")
        }else{
            print("blablabla")
        }
    }
    
//    @objc func onButtonPressed(sender: UIButton, stringUrl: String) {
//        if let url = URL(string: stringUrl) {
//            UIApplication.shared.openURL(url)
//        }
//    }

}
