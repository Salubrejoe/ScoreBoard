//
//  DragDropDelegate.swift
//  Counters
//
//  Created by Lore P on 10/05/2023.
//

import SwiftUI


struct DragDropDelegate: DropDelegate {
  
  let item: CounterEntity
  @Binding var listData: [CounterEntity]
  @Binding var current: CounterEntity?
  
  func performDrop(info: DropInfo) -> Bool {
    current = nil
    return true
  }
  
  func dropUpdated(info: DropInfo) -> DropProposal? {
    return DropProposal(operation: .move)
  }
  
  func dropEntered(info: DropInfo) {
    if item != current {
      let from = listData.firstIndex(of: current!)!
      let to = listData.firstIndex(of: item)!
      if listData[to].id != current!.id {
        listData.move(fromOffsets: IndexSet(integer: from),
                      toOffset: to > from ? to + 1 : to)
      }
    }
  }
}
