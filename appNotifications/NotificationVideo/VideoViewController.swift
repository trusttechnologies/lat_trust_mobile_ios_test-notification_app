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
    @IBOutlet weak var dialogView: UIView!
    var flagAudio: Bool = false
    @IBOutlet weak var audioButton: UIButton!{
        didSet{
            let origImage = UIImage(named: "audio_enabled_icon")
            let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
            audioButton.setImage(tintedImage, for: .normal)
            audioButton.tintColor = .white
        }
    }
    
    
    @IBAction func audioButton(_ sender: Any) {
        flagAudio = !flagAudio
    }
    
    @IBOutlet weak var closeView: UIView!{
        didSet{
            closeView.layer.cornerRadius = 18.0
        }
    }
    @IBOutlet weak var closeButton: UIButton!
    @IBAction func closeButton(_ sender: Any) {
        flagAudio = true
        self.dismiss(animated: true)
    }
    @IBOutlet weak var remainSecLabel: UILabel!
    
    @IBOutlet weak var videoView: UIView!

    var urlRightButton: String?
    var urlCenterButton: String?
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
            
            remainSecLabel.isHidden = true

            let videoURL = URL(string: content.notificationVideo!.videoUrl)
            let player = AVPlayer(url: videoURL!)
            let playerLayer = AVPlayerLayer(player: player)
            let controller = AVPlayerViewController()
            controller.player = player
            playerLayer.frame = self.videoView.bounds
            playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoView.layer.addSublayer(playerLayer)
            player.play()
            
            let interval = CMTime(seconds: 0.05,
                                  preferredTimescale: CMTimeScale(NSEC_PER_SEC))
            player.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using:
                { (progressTime) in

                    let seconds = CMTimeGetSeconds(progressTime)
                    let remaining = round(Double(content.notificationVideo!.minPlayTime) - seconds)
                    if(player.status == .readyToPlay ){
                        player.play()
                    }
                    player.isMuted = self.flagAudio
                    if(player.isMuted){
                        let origImage = UIImage(named: "audio_disabled_icon")
                        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
                        self.audioButton.setImage(tintedImage, for: .normal)
                        self.audioButton.tintColor = .white
                    }else{
                        let origImage = UIImage(named: "audio_enabled_icon")
                        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
                        self.audioButton.setImage(tintedImage, for: .normal)
                        self.audioButton.tintColor = .white
                    }
                    //lets move the slider thumb
                    if(seconds.isLess(than: Double(content.notificationVideo!.minPlayTime))){
                        self.remainSecLabel.text = "Quedan \(remaining) segundos"
                        self.remainSecLabel.isHidden = false
                        self.closeButton.isEnabled = false
                    }else{
                        self.remainSecLabel.isHidden = true
                        self.closeButton.isEnabled = true
                        self.closeView.fadeOut()
                        
                    }
            })
            
        }else{
            print("ERROR: URL DEL VIDEO NO VALIDA")
            
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
