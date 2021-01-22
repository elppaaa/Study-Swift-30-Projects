//
//  MainViewController.swift
//  Tumblr
//
//  Created by Yi Gu on 6/4/16.
//  Copyright © 2016 yigu. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
//  let transitionManager = TransitionManager()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // remove hairline
    navigationController?.toolbar.clipsToBounds = true
    navigationController?.view.backgroundColor = #colorLiteral(red: 0, green: 0.2563076615, blue: 0.5199578404, alpha: 1)
  }
  
  @IBAction func unwindToMainViewController (_ sender: UIStoryboardSegue){
    dismiss(animated: true, completion: nil)
  }
}
