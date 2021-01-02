//
//  ContactViewController.swift
//  GoodAsOldPhones
//
//  Copyright © 2016 Code School. All rights reserved.
//

import UIKit

class ContactViewController: UIViewController {
  
  @IBOutlet weak var scrollView: UIScrollView!
  
  override func viewDidLoad() {
    super.viewDidLoad()

    view.addSubview(scrollView)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    if #available(iOS 13.0, *) {
      let window = UIApplication.shared.keyWindow!
      scrollView.frame = CGRect(x: 0, y: window.safeAreaInsets.top, width: view.frame.width, height: view.frame.height - view.safeAreaInsets.bottom - view.safeAreaInsets.top)
    } else if #available(iOS 11.0, *) {
      scrollView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.frame.width, height: view.frame.height - view.safeAreaInsets.bottom - view.safeAreaInsets.top)
    } else {
      scrollView.frame = CGRect(x: 0, y: topLayoutGuide.length, width: view.frame.width, height: view.frame.height - topLayoutGuide.length - bottomLayoutGuide.length)
    }
    
    scrollView.contentSize = CGSize(width: self.view.frame.width, height: 800)
  }
}
