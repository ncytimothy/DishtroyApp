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
    @IBOutlet weak var forceSlider: UISlider!
    @IBOutlet weak var foodPicker: UIPickerView!
    var pickerDataSource = ["Tomato", "Cola"]
    
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
    
    
}

