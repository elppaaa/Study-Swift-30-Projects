//
//  NewsTableViewCell.swift
//  SimpleRSSReader
//
//  Copyright (c) 2015 AppCoda. All rights reserved.
//

import UIKit



class NewsTableViewCell: UITableViewCell {
  @IBOutlet weak var titleLabel:UILabel!
  
  @IBOutlet weak var descriptionLabel:UILabel! {
    didSet {
      descriptionLabel.numberOfLines = 4
    }
  }
  
  @IBOutlet weak var dateLabel:UILabel!

}
