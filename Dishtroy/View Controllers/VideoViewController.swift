//
//  VideoViewController.swift
//  Dishtroy
//
//  Created by Yimin Yuan on 3/31/18.
//  Copyright © 2018 Timothy Ng. All rights reserved.
//

import UIKit
import AVFoundation
import ReplayKit

class VideoViewController: UIViewController {
    
    // MARK: - Properties
    
    var selectedItem: String?
    var path: String?
    var player: AVPlayer?
    var userImage: UIImage?
    @IBOutlet weak var userImageView: UIImageView?
    var isUserImage: Bool = false
    let recorder = RPScreenRecorder.shared()
    var alert: UIAlertController? = nil
    @IBOutlet weak var doneButton: UIButton!
    
    // MARK: - Life cycle
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
       configureVideo()
       
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear called")
        startScreenRecording()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // MARK: - Actions
    
    @IBAction func pressDone(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Configure Video
    
    fileprivate func configureVideo() {
        
        if let selectedItem = selectedItem {
            let videoString = selectedItem + "_" + "explode"
            print("videoString: \(videoString)")
            path = Bundle.main.path(forResource: videoString, ofType: "mp4")
        }
        
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
            doneButton.isHidden = true
            self.view.addSubview(doneButton)
            
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
  
    // MARK: - Screen Recording
  
    private func startScreenRecording() {
        if recorder.isAvailable {
            recorder.startRecording(handler: { (error) in
                if let error = error {
                    print(error)
                }
            })
        }
    }
    
    private func stopScreenRecording() {
        if recorder.isRecording {
            recorder.stopRecording(handler: { (previewVC, error) in
                
                if let previewVC = previewVC {
                    previewVC.previewControllerDelegate = self
                    self.present(previewVC, animated: true, completion: nil)
                }
                
                if let error = error {
                    print(error)
                }
                
            })
        }
    }
    
    @objc func playerDidFinishPlaying(note: NSNotification) {
        self.player?.seek(to: kCMTimeZero)
        self.player?.pause()
        print("stopRecording...")
        stopScreenRecording()
    }
}

extension UIDevice {
    static func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
}

extension VideoViewController: RPPreviewViewControllerDelegate {
    
    func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
        self.dismiss(animated: true, completion: {
            self.doneButton.isHidden = false
        })
    }
}
