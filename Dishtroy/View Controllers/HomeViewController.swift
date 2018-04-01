//
//  ViewController.swift
//  Dishtroy
//
//  Created by Timothy Ng on 3/30/18.
//  Copyright © 2018 Timothy Ng. All rights reserved.
//

import UIKit
import CoreMotion
import AVFoundation

class HomeViewController: UIViewController, UIPickerViewDelegate, UINavigationControllerDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var foodPicker: UIPickerView!
    var pickerDataSource = ["Tomato", "Orange", "Apple", "Pick Yours"]
    var selectedFoodItem: String?
    var motionManager = CMMotionManager()
    @IBOutlet weak var titleLabel: UILabel!
    var foodImageViewTransform: CGFloat = 100
    @IBOutlet weak var albumButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    var userImage: UIImage?
  
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        foodPicker.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(self.didEnterBackground), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.willEnterForeground), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        albumButton.isHidden = true
        cameraButton.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.titleLabel.text = "Shake Me!"
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        albumButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
        animateInitialState()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Notification Methods
    @objc func didEnterBackground() {
        foodImageView.center.y = foodImageViewTransform
    }
    
    @objc func willEnterForeground() {
        foodImageView.center.y = foodImageViewTransform
        animateInitialState()
    }
    
    // MARK: - Animation

    fileprivate func configureMotion() {
        motionManager.accelerometerUpdateInterval = 1.0
        let animationOptions: UIViewAnimationOptions = [.curveLinear, .autoreverse, .repeat]
        if let currentQueue = OperationQueue.current {
            motionManager.startAccelerometerUpdates(to: currentQueue, withHandler: { data, error in
                if let data = data {
                    if data.acceleration.x >= 3.5 || data.acceleration.x <= -3.5 {
                        let videoVC = self.storyboard?.instantiateViewController(withIdentifier: "VideoVC") as! VideoViewController
                        videoVC.selectedItem = self.selectedFoodItem
                        videoVC.userImage = self.userImage
                        self.present(videoVC, animated: true, completion: nil)
                    }
                    
                    if data.acceleration.x >= 1 || data.acceleration.x <= -1 {
                        UIDevice.vibrate()
                        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 30.0, options: animationOptions, animations: {
                                self.foodImageView.center.y = 100
                        }, completion: nil)
                        self.titleLabel.text = "Harder!!!"
                    }
                }
            })
        }
    }
    
    @objc fileprivate func animateInitialState() {
        let animationOptions: UIViewAnimationOptions = [.curveEaseIn, .autoreverse, .repeat]
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 20.0, options: animationOptions, animations: {
            self.foodImageView.center.y = 300
        }, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureMotion()
}
    override var prefersStatusBarHidden: Bool {
        return true
        }
    
    // MARK: - Actions
    
    @IBAction func pickImageFromAlbum(_ sender: Any) {
        chooseSourceType(sourceType: .photoLibrary)
    }
    
    @IBAction func pickImageFromCamera(_ sender: Any) {
        chooseSourceType(sourceType: .camera)
    }
    
    // MARK: - Helper Choosing Source Type
    func chooseSourceType(sourceType: UIImagePickerControllerSourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = sourceType
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func pressDebug(_ sender: Any) {
        let videoVC = self.storyboard?.instantiateViewController(withIdentifier: "VideoVC") as! VideoViewController
        videoVC.selectedItem = self.selectedFoodItem
        videoVC.userImage = self.userImage
        self.present(videoVC, animated: true, completion: nil)
    }
    
}

// MARK: - FoodPickerView Data Source

extension HomeViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count
    }
    
    // MARK: - Configure UI for Food Item
    
    fileprivate func configurePickerTitle(_ row: Int) {
        foodImageView.contentMode = .center
        switch row {
        case 0:
            foodImageView.image = UIImage(named: "Tomato")
            selectedFoodItem = "Tomato"
            break
        case 1:
            foodImageView.image = UIImage(named: "Orange")
            selectedFoodItem = "Orange"
            break
        case 2:
            foodImageView.image = UIImage(named: "Apple")
            selectedFoodItem = "Apple"
            break
        case 3:
             foodImageView.image = UIImage(named: "QuestionMark")
             selectedFoodItem = "Standard"
            
        default:
            break
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        print("row: \(row)")
        configurePickerTitle(row)
        return pickerDataSource[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == 3 {
            albumButton.isHidden = false
            cameraButton.isHidden = false
        } else {
            albumButton.isHidden = true
            cameraButton.isHidden = true
        }
    }
}


extension HomeViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            foodImageView.image = image
            userImage = image
            foodImageView.contentMode = .scaleAspectFit
        }
        dismiss(animated: true, completion: nil)
    }
    
}




