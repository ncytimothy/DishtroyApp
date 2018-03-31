//
//  ViewController.swift
//  Dishtroy
//
//  Created by Timothy Ng on 3/30/18.
//  Copyright © 2018 Timothy Ng. All rights reserved.
//

import UIKit
import CoreMotion

class HomeViewController: UIViewController, UIPickerViewDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var foodPicker: UIPickerView!
    var pickerDataSource = ["Tomato", "Orange", "Apple"]
    var selectedFoodItem: String?
    var motionManager = CMMotionManager()
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        foodPicker.delegate = self
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.titleLabel.text = "Shake Me!"
        print("viewWillAppear called")
        animateInitialState()
    }

    fileprivate func configureMotion() {
        motionManager.accelerometerUpdateInterval = 1.0
        let animationOptions: UIViewAnimationOptions = [.curveLinear, .autoreverse, .repeat]
        if let currentQueue = OperationQueue.current {
            motionManager.startAccelerometerUpdates(to: currentQueue, withHandler: { data, error in
                if let data = data {
                    if data.acceleration.x >= 3.5 || data.acceleration.x <= -3.5 {
                        let videoVC = self.storyboard?.instantiateViewController(withIdentifier: "VideoVC") as! VideoViewController
                        videoVC.selectedItem = self.selectedFoodItem
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
    
    fileprivate func animateInitialState() {
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
    
    fileprivate func configureFoodItem(_ row: Int) {
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
        default:
            foodImageView.image = UIImage(named: "Tomato")
            selectedFoodItem = "Tomato"
            break
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        configureFoodItem(row)
        return pickerDataSource[row]
    }
}



