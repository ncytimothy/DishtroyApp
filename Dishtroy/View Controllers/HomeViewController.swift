//
//  ViewController.swift
//  Dishtroy
//
//  Created by Timothy Ng on 3/30/18.
//  Copyright © 2018 Timothy Ng. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UIPickerViewDelegate {
    
    // MARK: - Properties
    
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var foodPicker: UIPickerView!
    var pickerDataSource = ["Tomato", "Orange", "Apple"]
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        foodPicker.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            break
        case 1:
            foodImageView.image = UIImage(named: "Orange")
            break
        case 2:
            foodImageView.image = UIImage(named: "Apple")
            break
        default:
            foodImageView.image = UIImage(named: "Tomato")
            break
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        configureFoodItem(row)
        return pickerDataSource[row]
    }
}

