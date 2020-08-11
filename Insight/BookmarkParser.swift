//
//  ParseBookmarks.swift
//  Insight
//
//  Created by Harry Stanton on 01/01/2019.
//  Copyright © 2019 Harry Stanton. All rights reserved.
//

import Foundation
import SwiftSoup

struct BookmarkFolder {
  let name: String
  let bookmarks: [Bookmark]
}

struct Bookmark {
  let name: String
  let url: String
}

class BookmarkParser {
  func parse(data: String) -> [BookmarkFolder]? {
    do {
      let document: Document = try SwiftSoup.parse(data)
      
      let headerElements = try document.select("h3").array()
      let bookmarkElements = try document.select("h3+dl")
      
      if headerElements.count == bookmarkElements.array().count {
        var bookmarks = [BookmarkFolder]()
        for (index, element) in headerElements.enumerated() {
          let parsedBookmarks = try bookmarkElements.array()[index].select("a").array().map{ element in
            return Bookmark(name: try element.text(), url: try element.attr("href"))
          }
          bookmarks.append(BookmarkFolder(name: try element.text(), bookmarks: parsedBookmarks))
        }
        return bookmarks
      }
      return nil
    } catch {
      return nil
    }
  }
}
