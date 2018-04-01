//
//  VideoViewController.swift
//  Dishtroy
//
//  Created by Yimin Yuan on 3/31/18.
//  Copyright © 2018 Timothy Ng. All rights reserved.
//

import UIKit
import AVFoundation

class VideoViewController: UIViewController {
    
    // MARK: - Properties
    
    var selectedItem: String?
    var path: String?
    var player: AVPlayer?
    var userImage: UIImage?
    @IBOutlet weak var userImageView: UIImageView?
    var isUserImage: Bool = false
    
    // MARK: - Life cycle
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if let selectedItem = selectedItem {
            let videoString = selectedItem + "_" + "explode"
            print("videoString: \(videoString)")
            path = Bundle.main.path(forResource: videoString, ofType: "mp4")
        }
        configureVideo()
    }
  
    
    fileprivate func configureVideo() {
        if let urlPath = path {
            print("configureVideo called")
            let url = URL(fileURLWithPath: urlPath)
            let player = AVPlayer(url: url)
            let playerLayer = AVPlayerLayer(player: player)
            
            if selectedItem == "Standard" {
                isUserImage = true
            }
            
            NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
            playerLayer.frame = self.view.frame
            playerLayer.videoGravity = .resizeAspectFill
            self.view.layer.addSublayer(playerLayer)
            if let userImageView = userImageView, isUserImage {
                userImageView.image = userImage
                userImageView.alpha = 0.5
                print("addSubViewOK")
                self.view.addSubview(userImageView)
            }
            player.seek(to: kCMTimeZero)
            player.play()
            UIDevice.vibrate()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear called")
    }
    
    @objc func playerDidFinishPlaying(note: NSNotification) {
        self.player?.seek(to: kCMTimeZero)
        self.player?.pause()
        self.dismiss(animated: true)
    }
}

extension UIDevice {
    static func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
}
