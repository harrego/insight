//
//  BookmarkAnalyzer.swift
//  Insight
//
//  Created by Harry Stanton on 02/01/2019.
//  Copyright © 2019 Harry Stanton. All rights reserved.
//

import Foundation

struct BookmarkWebsite {
  let name: String
  let url: String
  let percentage: Int
}

class BookmarkAnalyzer {
  func analyze(folder: BookmarkFolder) -> [BookmarkWebsite] {
    var foundWebsites = [String: Int]()
    let urls = folder.bookmarks.map { $0.url }
    
    for url in urls {
      if let hostUrl = URL(string: url)?.host {
        if foundWebsites[hostUrl] != nil {
          foundWebsites[hostUrl]! += 1
        } else {
          foundWebsites[hostUrl] = 1
        }
      }
    }
  
    return foundWebsites.map {
      let percentage = Float($0.value) / Float(urls.count) * 100
      return BookmarkWebsite(name: $0.key, url: $0.key, percentage: Int(floor(percentage)))
    }
  }
}
