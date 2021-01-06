//
//  TableKeys.swift
//  FacebookMe
//
//  Copyright © 2017 Yi Gu. All rights reserved.
//

import Foundation

public struct TableKeys {
  init() { }
  
  static let image = RowKey.image
  static let title = RowKey.title
  static let subtitle = RowKey.subTitle
  
  static func populate2(withUser user: FBMeUser) -> [TableSectionData] {
    return [
      TableSectionData(sectionName: nil, rows: [
        [image: user.avatarName, title: user.name, subtitle: "View your profile"],
      ]),
      TableSectionData(sectionName: nil, rows: [
        [image: Specs.imageName.friends, title: "Friends"],
        [image: Specs.imageName.events, title: "Events"],
        [image: Specs.imageName.groups, title: "Groups"],
        [image: Specs.imageName.education, title: user.education],
        [image: Specs.imageName.townHall, title: "Town Hall"],
        [image: Specs.imageName.instantGames, title: "Instant Games"],
        [title: Specs.String.seeMore]
      ]),
      TableSectionData(sectionName: "FAVORITES", rows: [
        [title: Specs.String.addFavorites]
      ]),
      TableSectionData(sectionName: nil, rows: [
        [image: Specs.imageName.settings, title: "Settings"],
        [image: Specs.imageName.privacyShortcuts, title: "Privacy Shortcuts"],
        [image: Specs.imageName.helpSupport, title: "Help and Support"]
      ]),
      TableSectionData(sectionName: nil, rows: [
        [title: Specs.String.logout]
      ]),
    ]
  }
}

enum RowKey {
  case image, title, subTitle
}

typealias RowModel = [RowKey: String]

struct TableSectionData {
  let sectionName: String?
  let rows: [RowModel]
}




