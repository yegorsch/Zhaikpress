//
//  String+Additions.swift
//  news
//
//  Created by Егор on 10/13/17.
//  Copyright © 2017 Yegor's Mac. All rights reserved.
//

import Foundation

extension String {

  func replace(_ index: Int, _ newChar: Character) -> String {
    var modifiedString = String()
    for (i, char) in self.characters.enumerated() {
      modifiedString += String((i == index) ? newChar : char)
    }
    return modifiedString
  }

  subscript (i: Int) -> Character {
    return self[index(startIndex, offsetBy: i)]
  }

  subscript (i: Int) -> String {
    return String(self[i] as Character)
  }

}
