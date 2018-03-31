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
    
    var selectedItem: String?
    var path: String?
    var player: AVPlayer?
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        path = Bundle.main.path(forResource: selectedItem!, ofType: "mp4")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
    
    @objc func playerDidFinishPlaying(note: NSNotification) {
        self.player?.seek(to: kCMTimeZero)
        self.player?.pause()
        self.dismiss(animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UIDevice {
    static func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
}
