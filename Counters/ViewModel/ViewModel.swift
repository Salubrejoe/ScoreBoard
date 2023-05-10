//
//  ViewModel.swift
//  Counters
//
//  Created by Lore P on 10/05/2023.
//

import CoreData
import UIKit
import SwiftUI

class ViewModel: ObservableObject {
  
  // MARK: -  PROPERTIES
  // VIBRATION
  let hapticImpact = UIImpactFeedbackGenerator(style: .medium)
  @AppStorage("isVibrating") var isVibrating = true
  
  
  // ACCENT COLOR
  @AppStorage("accentColor") var accentColor: Color = Color(uiColor: UIColor.systemPink)

  // GRID LAYOUT
  let columns = [GridItem(.adaptive(minimum: 300))]
  
  
  
  // MARK: - CORE DATA
  // 1 - Create and init() container
  let container: NSPersistentContainer
  init() {
    container = NSPersistentContainer(name: "CounterContainer")
    container.loadPersistentStores { description, error in
      if let error = error {
        print("Error loading from container; \(error)")
      } else {
        print("Successfully loaded from container!")
      }
    }
  }
  
  // MARK: - Fetch model
  // 2 - Fetch request and main array
  @Published var counters: [CounterEntity] = []
  func fetchCounters() {
    let request = NSFetchRequest<CounterEntity>(entityName: "CounterEntity")
    
    do {
      counters = try container.viewContext.fetch(request)
    } catch {
      print("Failed to fetch counters: \(error)")
    }
  }
  
  
  // MARK: - crud
  // 3 - Funcitions to Add/Delete/Save
  func addCounter(name: String) {
    let newCounter = CounterEntity(context: container.viewContext)
    newCounter.id = UUID()
    newCounter.name = name
    newCounter.dateCreated = Date()
    newCounter.soundIsOn = false
    newCounter.count = 0
    newCounter.numberOfSteps = 1
    
    let uiColor = UIColor(goodColors.randomElement() ?? Color.black)
    let red = uiColor.cgColor.components?[0] ?? 0
    let green = uiColor.cgColor.components?[1] ?? 0
    let blue = uiColor.cgColor.components?[2] ?? 0
    
    
    newCounter.red = red
    newCounter.green = green
    newCounter.blue = blue
    newCounter.opacity = 0.5
    
    counters.insert(newCounter, at: 0)
    
    saveCounters()
  }
  
  func saveCounters() {
    do {
      try container.viewContext.save()
      fetchCounters() // So this func reloads the main array
    } catch {
      print("Error saving counter: \(error)")
    }
    sortByDate()
  }
  
  func deleteCounter(indexSet: IndexSet) {
    guard let index = indexSet.first else { return }
    container.viewContext.delete(counters[index])
    saveCounters()
  }
  
  func deleteAll() {
    
    for counter in counters {
      container.viewContext.delete(counter)
    }
    saveCounters()
  }
  
  

}


// MARK: - ACTIONS
extension ViewModel {
  
  func resetAll() {
    for i in counters.indices {
      counters[i].numberOfSteps = 1
      counters[i].count = 0
      counters[i].soundIsOn = false
    }
    saveCounters()
  }
  
  
  func vibrate() {
    if isVibrating {
      hapticImpact.impactOccurred()
    }
  }
  
  
  func sortByDate() {
    counters = counters.sorted(by: { c1, c2 in
      c1.wrappedDateCreated > c2.wrappedDateCreated
    })
  }

  func sortAZ() {
    counters = counters.sorted(by: { c1, c2 in
      c1.wrappedName < c2.wrappedName
    })
  }

  func sortZA() {
    counters = counters.sorted(by: { c1, c2 in
      c1.wrappedName > c2.wrappedName
    })
  }
  
  func sortCountDescending() {
    counters = counters.sorted(by: { c1, c2 in
      c1.count > c2.count
    })
  }
  
  func sortCountAscending() {
    counters = counters.sorted(by: { c1, c2 in
      c1.count < c2.count
    })
  }
}
