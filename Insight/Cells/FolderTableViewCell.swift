//
//  FolderTableViewCell.swift
//  Insight
//
//  Created by Harry Stanton on 02/01/2019.
//  Copyright © 2019 Harry Stanton. All rights reserved.
//

import Cocoa

class FolderTableViewCell: NSTableCellView {
  
  @IBOutlet weak var nameLabel: NSTextField!
  @IBOutlet weak var countLabel: NSTextField!
  
  override func draw(_ dirtyRect: NSRect) {
    super.draw(dirtyRect)
    
    // Drawing code here.
  }
  
}
