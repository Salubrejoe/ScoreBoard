//
//  CounterEntity+CoreDataProperties.swift
//  Counters
//
//  Created by Lore P on 10/05/2023.
//
//

import SwiftUI
import CoreData


extension CounterEntity {
  
  @nonobjc public class func fetchRequest() -> NSFetchRequest<CounterEntity> {
    return NSFetchRequest<CounterEntity>(entityName: "CounterEntity")
  }
  
  @NSManaged public var blue: Double
  @NSManaged public var count: Int16
  @NSManaged public var dateCreated: Date?
  @NSManaged public var green: Double
  @NSManaged public var id: UUID?
  @NSManaged public var name: String?
  @NSManaged public var numberOfSteps: Int16
  @NSManaged public var opacity: Double
  @NSManaged public var red: Double
  @NSManaged public var soundIsOn: Bool
  
  
  public var wrappedNumberOfSteps: Int {
    return Int(numberOfSteps)
  }
  
  public var wrappedName: String {
    return name ?? "Unknown Name"
  }
  
  public var wrappedDateCreated: Date {
    return dateCreated ?? Date()
  }
  
  public var formattedNumberOfSteps: String {
    if numberOfSteps > 0 {
      return "+\(numberOfSteps)"
    } else {
      return "\(numberOfSteps)"
    }
  }
  
  func background() -> Color {
    return Color(red: self.red, green: self.green, blue: self.blue, opacity: self.opacity)
  }
}

extension CounterEntity : Identifiable {
  
}
