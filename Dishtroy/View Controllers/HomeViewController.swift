//
//  ViewController.swift
//  Dishtroy
//
//  Created by Timothy Ng on 3/30/18.
//  Copyright © 2018 Timothy Ng. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var forceSlider: UISlider!
    @IBOutlet weak var foodPicker: UIPickerView!
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

}

