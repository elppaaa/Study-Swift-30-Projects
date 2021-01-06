//
//  FBMeViewController.swift
//  FacebookMe
//
//  Copyright © 2017 Yi Gu. All rights reserved.
//

import UIKit

class FBMeViewController: FBMeBaseViewController {
  
  fileprivate var user: FBMeUser {
    get {
      return FBMeUser(name: "BayMax", education: "CMU")
    }
  }
  
  fileprivate var tableViewDataSource: [TableSectionData] {
    get {
      return TableKeys.populate2(withUser: user)
    }
  }
  
  private let tableView: UITableView = {
    let view = UITableView(frame: .zero, style: .grouped)
    view.register(FBMeBaseCell.self, forCellReuseIdentifier: FBMeBaseCell.identifier)
    return view
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Facebook"
    navigationController?.navigationBar.barTintColor = Specs.color.tint
    
    tableView.delegate = self
    tableView.dataSource = self
    view.addSubview(tableView)
    
    // Set layout for tableView.
    tableView.translatesAutoresizingMaskIntoConstraints = false
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[tableView]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["tableView": tableView]))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[tableView]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["tableView": tableView]))
  }
  
  fileprivate func rows(at section: Int) -> [RowModel] {
    tableViewDataSource[section].rows
  }
  
  fileprivate func title(at section: Int) -> String? {
    tableViewDataSource[section].sectionName
  }
  
  fileprivate func rowModel(at indexPath: IndexPath) -> RowModel {
    rows(at: indexPath.section)[indexPath.row]
  }
}

extension FBMeViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return tableViewDataSource.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return rows(at: section).count
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return title(at: section)
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let modelForRow = rowModel(at: indexPath)
    
    var cell: UITableViewCell!
    
    guard let title = modelForRow[.title] else {
      fatalError("\(indexPath.description)Title Not Founded")
    }
    
    // title & subtitle
    if title == user.name {
      cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
      cell.detailTextLabel?.text = modelForRow[.subTitle]
    } else {
      cell = tableView.dequeueReusableCell(withIdentifier: FBMeBaseCell.identifier, for: indexPath)
    }
    
    cell.textLabel?.text = title
    
    // image set
    if let imageName = modelForRow[.image] {
      cell.imageView?.image = UIImage(named: imageName)
    } else if title == Specs.String.logout {
      cell.imageView?.image = nil
    } else {
      cell.imageView?.image = UIImage()
    }
    
    return cell
  }
}

extension FBMeViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let modelForRow = rowModel(at: indexPath)
    
    guard let title = modelForRow[.title] else {
      fatalError("\(indexPath.description)Title Not Founded")
    }
    
    if title == user.name {
      return 64.0
    } else {
      return 44.0
    }
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    let modelForRow = rowModel(at: indexPath)
    
    guard let title = modelForRow[.title] else {
      fatalError("\(indexPath.description)\nTitle Not Founded")
    }
    
    if title == Specs.String.seeMore || title == Specs.String.addFavorites {
      cell.textLabel?.textColor = Specs.color.tint
      cell.accessoryType = .none
    } else if title == Specs.String.logout {
      cell.textLabel?.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
      cell.textLabel?.textColor = Specs.color.red
      cell.textLabel?.textAlignment = .center
      cell.accessoryType = .none
    } else {
      cell.accessoryType = .disclosureIndicator
    }
  }
}
