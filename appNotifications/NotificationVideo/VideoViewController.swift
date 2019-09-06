//
//  VideoViewController.swift
//  appNotifications
//
//  Created by Jesenia Salazar on 9/5/19.
//  Copyright © 2019 Cristian Parra. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import MaterialComponents
import MediaPlayer
import AudioToolbox

class VideoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var closeButton: UIButton!
    @IBAction func closeButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBOutlet weak var videoView: UIView!

    var urlRightButton: String?
    var urlCenterButton: String?
    @IBOutlet weak var buttonC: MDCButton!{
        didSet{
            buttonC.addTarget(
                self,
                action: #selector(onRightButtonPressed(sender:)),
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
    
    @objc func onRightButtonPressed(sender: UIButton) {
        if let url = URL(string: urlRightButton!) {
            UIApplication.shared.openURL(url)
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
    func fillVideo(content: GenericNotification!) {
        
        //Set video
        if(verifyUrl(urlString: content.notificationVideo?.videoUrl)){

            let videoURL = URL(string: content.notificationVideo!.videoUrl)
            let player = AVPlayer(url: videoURL!)
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = self.videoView.bounds
            playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill;
            playerLayer.needsDisplayOnBoundsChange = true
            videoView.layer.addSublayer(playerLayer)
            player.play()
        }else{
            //imageView.isHidden = true
        }
        
        let buttons = content.notificationVideo?.buttons
        let buttonCounter = buttons!.count
        if(buttonCounter == 1){
            
            buttonC.isHidden = true
            buttonR.setTitle(buttons![0].text, for: .normal)
            buttonR.setupButtonWithType(color: buttons![0].color, type: .whiteButton, mdcType: .text)
            urlRightButton = buttons![0].action
        }
        
        if(buttonCounter == 2){
            
            buttonC.setTitle(buttons![1].text, for: .normal)
            buttonC.setupButtonWithType(color: buttons![1].color, type: .whiteButton, mdcType: .text)
            urlCenterButton = buttons![1].action
            buttonR.setTitle(buttons![0].text, for: .normal)
            buttonR.setupButtonWithType(color: buttons![0].color, type: .whiteButton, mdcType: .text)
            urlRightButton = buttons![0].action
            
        }
    }
}
