//
//  Extensions.swift
//  Counters
//
//  Created by Lore P on 10/05/2023.
//

import SwiftUI


// Get random Floats for random colorComponents assignment
extension CGFloat {
  static func random() -> CGFloat {
    return CGFloat(arc4random()) / CGFloat(UInt32.max)
  }
}


// Init Color(hex:)
extension Color {
  init(hex: String) {
    // Remove the "#" character from the beginning of the string
    var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    if hexString.hasPrefix("#") {
      hexString.remove(at: hexString.startIndex)
    }
    
    // Convert the hex string to a 6-digit integer
    var rgbValue: UInt64 = 0
    Scanner(string: hexString).scanHexInt64(&rgbValue)
    
    // Create a Color object from the integer value
    self.init(red: Double((rgbValue >> 16) & 0xFF) / 255.0,
              green: Double((rgbValue >> 8) & 0xFF) / 255.0,
              blue: Double(rgbValue & 0xFF) / 255.0)
  }
}


// Store Color in @AppStorage
extension Color: RawRepresentable {
  
  public init?(rawValue: String) {
    
    guard let data = Data(base64Encoded: rawValue) else{
      self = .black
      return
    }
    
    do{
      let color = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data) ?? .black
      self = Color(color)
    }catch{
      self = .black
    }
    
  }
  
  public var rawValue: String {
    
    do{
      let data = try NSKeyedArchiver.archivedData(withRootObject: UIColor(self), requiringSecureCoding: false) as Data
      return data.base64EncodedString()
      
    }catch{
      
      return ""
      
    }
    
  }
  
}


// Good Colors
let systemColors = [
  
  Color(uiColor: UIColor.systemPink),
  Color(uiColor: UIColor.systemRed),
  Color(uiColor: UIColor.systemOrange),
  Color(uiColor: UIColor.systemYellow),
  Color(uiColor: UIColor.systemGreen),
  Color(uiColor: UIColor.systemTeal),
  Color(uiColor: UIColor.systemBlue),
  Color(uiColor: UIColor.systemIndigo),
  Color(uiColor: UIColor.systemPurple),
  Color(uiColor: UIColor.label)
]

let goodColors = [
  Color(uiColor: UIColor.systemPink),
  Color(uiColor: UIColor.systemRed),
  Color(uiColor: UIColor.systemOrange),
  Color(uiColor: UIColor.systemYellow),
  Color(uiColor: UIColor.systemGreen),
  Color(uiColor: UIColor.systemTeal),
  Color(uiColor: UIColor.systemBlue),
  Color(uiColor: UIColor.systemIndigo),
  Color(uiColor: UIColor.systemPurple),
  Color(hex: "#ff9ff3"),
  Color(hex: "#f368e0"),
  Color(hex: "#feca57"),
  Color(hex: "#ff9f43"),
  Color(hex: "#ff6b6b"),
  Color(hex: "#ee5253"),
  Color(hex: "#48dbfb"),
  Color(hex: "#1dd1a1"),
  Color(hex: "#1dd1a1"),
  Color(hex: "#10ac84"),
  Color(hex: "#5f27cd"),
  Color(hex: "#01a3a4"),
  Color(hex: "#C4E538"),
  Color(hex: "#009432"),
  Color(hex: "#009432"),
  Color(hex: "#FFC312"),
  Color(hex: "#F79F1F"),
  Color(hex: "#12CBC4"),
  Color(hex: "#D980FA")
]
