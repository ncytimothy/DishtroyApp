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
    
    // MARK: - Life cycle
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if let selectedItem = selectedItem {
            let videoString = selectedItem + "_" + "explode"
            path = Bundle.main.path(forResource: videoString, ofType: "mp4")
        }
    }
    
    fileprivate func configureVideo() {
        if let urlPath = path {
            let url = URL(fileURLWithPath: urlPath)
            let player = AVPlayer(url: url)
            let playerLayer = AVPlayerLayer(player: player)
            
            NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
            
            playerLayer.frame = self.view.frame
            playerLayer.videoGravity = .resizeAspectFill
            self.view.layer.addSublayer(playerLayer)
            player.seek(to: kCMTimeZero)
            player.play()
            UIDevice.vibrate()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureVideo()
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
