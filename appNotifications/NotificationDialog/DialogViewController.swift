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
        self.dismiss(animated: true)
    }
    
    @IBOutlet weak var closeButton: UIButton!
    @IBAction func closeButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBOutlet weak var stackView: UIStackView!
    
    
    var urlLeftButton: String?
    var urlCenterButton: String?
    var urlRightButton: String?
    
    @IBOutlet weak var buttonL: MDCButton!{
        didSet{
            buttonL.addTarget(
                self,
                action: #selector(onLeftButtonPressed(sender:)),
                for: .touchUpInside)
        }
    }
    @IBOutlet weak var buttonC: MDCButton!{
        didSet{
            buttonC.addTarget(
                self,
                action: #selector(onCenterButtonPressed(sender:)),
                for: .touchUpInside)
        }
    }
    @IBOutlet weak var buttonR: MDCButton!{
        didSet{
            buttonR.addTarget(
                self,
                action: #selector(onRightButtonPressed(sender:)),
                for: .touchUpInside)
        }
    }
    
    
    //MARK: set the dialog background
    func setBackground(color: backgroundColor){
        switch color {
        case .SOLID:
            view.backgroundColor = UIColor(red:0.17, green:0.16, blue:0.16, alpha:1)
        case .TRANSPARENT:
            view.backgroundColor = UIColor(red:0.17, green:0.16, blue:0.16, alpha:0.6)
        case .NO_BACKGROUND:
            view.backgroundColor = UIColor.clear
        }
    }
    
    //MARK: set the dialog content
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
                persistenceButton.isHidden = false
                setBackground(color: .NO_BACKGROUND)
            }else{
                persistenceButton.isEnabled = false
                persistenceButton.isHidden = true
                setBackground(color: .TRANSPARENT)
            }
            
            let buttons = content.notificationDialog?.buttons
            let buttonCounter = buttons!.count
            
            if(buttonCounter == 1){
                buttonL.isHidden = true
                buttonC.isHidden = true
                buttonR.setTitle(buttons![0].text, for: .normal)
                buttonR.setupButtonWithType(color: buttons![0].color, type: .whiteButton, mdcType: .text)
                urlRightButton = buttons![0].action
            }
            
            if(buttonCounter == 2){
                buttonL.isHidden = true
                buttonC.setTitle(buttons![1].text, for: .normal)
                buttonC.setupButtonWithType(color: buttons![1].color, type: .whiteButton, mdcType: .text)
                urlCenterButton = buttons![1].action
                buttonR.setTitle(buttons![0].text, for: .normal)
                buttonR.setupButtonWithType(color: buttons![0].color, type: .whiteButton, mdcType: .text)
                urlRightButton = buttons![0].action
                
            }
            
            if(buttonCounter == 3){
                buttonL.setTitle(buttons![2].text, for: .normal)
                buttonL.setupButtonWithType(color: buttons![2].color, type: .whiteButton, mdcType: .contained)
                urlLeftButton = buttons![2].action
                buttonC.setTitle(buttons![1].text, for: .normal)
                buttonC.setupButtonWithType(color: buttons![1].color, type: .whiteButton, mdcType: .text)
                urlCenterButton = buttons![1].action
                buttonR.setTitle(buttons![0].text, for: .normal)
                buttonR.setupButtonWithType(color: buttons![0].color, type: .whiteButton, mdcType: .text)
                urlRightButton = buttons![0].action
                
            }

            
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
    
    @objc func onLeftButtonPressed(sender: UIButton) {
        if let url = URL(string: urlLeftButton!) {
            UIApplication.shared.openURL(url)
        }
    }
    @objc func onCenterButtonPressed(sender: UIButton) {
        if let url = URL(string: urlCenterButton!) {
            UIApplication.shared.openURL(url)
        }
    }
    @objc func onRightButtonPressed(sender: UIButton) {
        if let url = URL(string: urlRightButton!) {
            UIApplication.shared.openURL(url)
        }
    }

}
