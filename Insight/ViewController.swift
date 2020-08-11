//
//  ViewController.swift
//  Insight
//
//  Created by Harry Stanton on 01/01/2019.
//  Copyright © 2019 Harry Stanton. All rights reserved.
//

import Cocoa

struct AnalyzedBookmarkFolder {
  let name: String
  let bookmarks: [BookmarkWebsite]
}

class ViewController: NSViewController {
  
  let parseBookmarks = BookmarkParser()
  let bookmarkAnalyzer = BookmarkAnalyzer()
  
  var data = [AnalyzedBookmarkFolder]()
  var selectedData = 0
  
  @IBOutlet weak var tableView: NSTableView!
  @IBOutlet weak var foldersTableView: NSTableView!
  
  @IBAction func open(_ sender: Any) {
    let dialog = NSOpenPanel()
    
    dialog.title = "Choose Safari bookmark file"
    dialog.canChooseDirectories = false
    dialog.canChooseFiles = true
    dialog.allowsMultipleSelection = false
    dialog.allowedFileTypes = ["html"]
    
    if (dialog.runModal() == NSApplication.ModalResponse.OK) {
      if let openedPath = dialog.url?.path {
        if let binaryData = FileManager.default.contents(atPath: openedPath), let fileData = String(data: binaryData, encoding: .utf8) {
          if let parsedData = parseBookmarks.parse(data: fileData) {
            data = parsedData.map {
              AnalyzedBookmarkFolder(name: $0.name, bookmarks: bookmarkAnalyzer.analyze(folder: $0))
            }
            
            tableView.reloadData()
            foldersTableView.reloadData()
            
            selectedData = 0
            foldersTableView.selectRowIndexes(IndexSet(arrayLiteral: 0), byExtendingSelection: false)
          }
        }
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.delegate = self
    tableView.dataSource = self
    
    foldersTableView.delegate = self
    foldersTableView.dataSource = self
  }
  
  override var representedObject: Any? {
    didSet {
      // Update the view, if already loaded.
    }
  }
  
  
}

extension ViewController: NSTableViewDelegate, NSTableViewDataSource {
  func numberOfRows(in tableView: NSTableView) -> Int {
    if tableView == self.tableView {
      if data.count > 0 {
        print(selectedData)
        return data[selectedData].bookmarks.count
      }
    } else if tableView == self.foldersTableView {
      return data.count
    }
    
    return 0
  }
  
  func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
    if tableView == self.tableView {
      return 45
    } else if tableView == self.foldersTableView {
      return 55
    }
    
    return 0
  }
  
  func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
    
    if tableView == self.tableView {
      if data.count > 0 {
        let item = data[selectedData].bookmarks[row]
        
        if tableColumn == tableView.tableColumns[0] {
          if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "nameCell"), owner: nil) as? NameTableViewCell {
            cell.nameLabel.stringValue = item.name
            
            return cell
          }
        } else if tableColumn == tableView.tableColumns[1] {
          if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "infoCell"), owner: nil) as? InfoTableViewCell {
            cell.descriptionLabel.stringValue = "\(item.percentage)%"
            
            return cell
          }
        }
      }
    } else if tableView == self.foldersTableView {
      if data.count > 0 {
        let item = data[row]
        
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "folderCell"), owner: nil) as? FolderTableViewCell {
          cell.nameLabel.stringValue = item.name
          cell.countLabel.stringValue = "\(item.bookmarks.count) items"
          
          return cell
        }
      }
    }
    
    return nil
  }
  
  func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
    if tableView == self.foldersTableView {
      selectedData = row
      self.tableView.reloadData()
    }
    
    return true
  }
}

