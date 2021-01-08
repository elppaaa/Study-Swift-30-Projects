//
//  ArtistModel.swift
//  Artistry
//
//  Created by JK on 2021/01/06.
//  Copyright © 2021 RayWenderlich. All rights reserved.
//

import UIKit

struct ArtistModel {
  init() { }
  private struct Artists: Decodable {
    let artists: [Artist]
  }
  
  static func getJSON() -> [Artist] {
    guard let url = Bundle.main.url(forResource: "artists", withExtension: "json") else {
      fatalError("File Not Founded")
    }
    
    do {
      let data = try Data(contentsOf: url)
      let decoded = try JSONDecoder().decode(Artists.self, from: data)
      return decoded.artists
      
    } catch {
      fatalError("Decode Error")
    }
  }
}

struct Artist: Decodable {
  let name: String
  let bio: String
  let image: UIImage
  var works: [Work]
  
  private enum CodingKeys: String, CodingKey {
    case name, bio, image, works
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.name = (try? container.decode(String.self, forKey: .name)) ?? ""
    let imgName = (try? container.decode(String.self, forKey: .image)) ?? ""
    self.image = UIImage(named: imgName)!
    self.bio = (try? container.decode(String.self, forKey: .bio)) ?? ""
    self.works = (try? container.decode([Work].self, forKey: .works)) ?? []
  }
}

struct Work: Decodable {
  let title: String
  let image: UIImage
  let info: String
  var isExpanded: Bool
  
  private enum CodingKeys: String, CodingKey {
    case title, image, info, isExpanded
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.title = (try? container.decode(String.self, forKey: .title)) ?? ""
    let imgName = (try? container.decode(String.self, forKey: .image)) ?? ""
    self.image = UIImage(named: imgName)!
    self.info = (try? container.decode(String.self, forKey: .info)) ?? ""
    self.isExpanded = false
  }
}
