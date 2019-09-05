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
    
    @IBOutlet weak var persistenceButton: UIButton!
    @IBAction func persistenceButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBOutlet weak var closeButton: UIButton!
    @IBAction func closeButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var videoLabel: UILabel!
    var urlRightButton: String?
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
//            guard let url = URL(string: content.notificationVideo!.videoUrl) else {
//                return
//            }

            let videoURL = URL(string: content.notificationVideo!.videoUrl)
            let player = AVPlayer(url: videoURL!)
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = self.videoView.bounds
            videoView.layer.addSublayer(playerLayer)
            player.play()
        }else{
            //imageView.isHidden = true
        }
        
        //Set the close button
//        if(!(content.notificationVideo?.isCancelable ?? true)){
//            closeButton.isEnabled = false
//            closeButton.isHidden = true
//        }else{
//            closeButton.isEnabled = true
//            closeButton.isHidden = false
//        }
        
        //Set touching outside the dialog process
        if(!(content.notificationVideo?.isPersistent ?? false)){
            persistenceButton.isEnabled = true
            persistenceButton.isHidden = false
            setBackground(color: .NO_BACKGROUND)
        }else{
            persistenceButton.isEnabled = false
            persistenceButton.isHidden = true
            setBackground(color: .TRANSPARENT)
        }
        
        let buttons = content.notificationVideo?.buttons
        let buttonCounter = buttons!.count
        if buttonCounter != 0{
            buttonR.setTitle(buttons![0].text, for: .normal)
            buttonR.setupButtonWithType(color: buttons![0].color, type: .whiteButton, mdcType: .text)
            urlRightButton = buttons![0].action
        }
    }
}
