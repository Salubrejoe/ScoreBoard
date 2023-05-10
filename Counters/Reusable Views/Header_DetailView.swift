//
//  Header_DetailView.swift
//  Counters
//
//  Created by Lore P on 12/05/2023.
//

import SwiftUI

struct Header_DetailView: View {
  @Environment(\.dismiss) var dismiss
  
  // MARK: - PROPERTIES
  @ObservedObject var counter: CounterEntity
  @ObservedObject var viewModel: ViewModel
  
  @State var selectedColor: Color = .black
  @State private var showingResetAlert = false
  @State private var showingDeleteAlert = false
  
  
  // MARK: - BODY
  var body: some View {
    VStack {
      
      HStack(alignment: .center) {
        
        // MARK: - Back Button
        Button {
          dismiss()
        } label: {
          Image(systemName: "chevron.left")
        }
        .padding(.trailing)
        Spacer()
        
        // MARK: - Title
        Text(counter.name?.uppercased() ?? "UNKNOWN NAME")
          .font(.largeTitle)
        Spacer()
        
        // MARK: - Delete Button
        Button {
          showingDeleteAlert.toggle()
        } label: {
          Image(systemName: "trash")
            .foregroundColor(.red)
        }
        .alert("Delete counter?", isPresented: $showingDeleteAlert) {
          Button("Delete", role: .destructive) { deleteCounter() }
          Button("Cancel", role: .cancel) {}
        }
      }
      .bold()
      .padding(.top, 20)
      
      HStack {
        // MARK: - Sound Button
        Button {
          counter.soundIsOn.toggle()
        } label: {
          Image(systemName: counter.soundIsOn ? "speaker.wave.2.fill" : "speaker.slash.fill")
        }
        .padding(.leading, 20)
        
        // MARK: - Color Picker
        SquareColorPickerView(colorValue: $selectedColor)
          .onChange(of: selectedColor) { _ in
            updateColor()
          }
        Spacer()
        
        // MARK: - Reset Button
        Button {
          showingResetAlert.toggle()
        } label: {
          Text("Reset")
        }
        .alert("Reset counter?", isPresented: $showingResetAlert) {
          Button("Reset") { resetCounter() }
          Button("Cancel", role: .cancel) {}
        }
        .padding(.trailing, 20)
        
      }// HStack
      .font(.headline)
      .foregroundColor(viewModel.accentColor)
    }
  }
  

  // MARK: - ACTIONS
  func resetCounter() {
    counter.count = 0
    counter.numberOfSteps = 1
  }
  
  func deleteCounter() {
    if let index = viewModel.counters.firstIndex(where: { $0.id == counter.id }) {
      viewModel.deleteCounter(indexSet: IndexSet(integer: index))
    }
  }
  
  func updateColor() {
    let red = UIColor(selectedColor).cgColor.components?[0] ?? 1
    let green = UIColor(selectedColor).cgColor.components?[1] ?? 0
    let blue = UIColor(selectedColor).cgColor.components?[2] ?? 0
    
    counter.red = red
    counter.green = green
    counter.blue = blue
  }
}

//struct Header_DetailView_Previews: PreviewProvider {
//    static var previews: some View {
//      Header_DetailView(counter: CounterEntity(), viewModel: <#T##ViewModel#>)
//    }
//}
