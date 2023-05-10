//
//  AddNewCounterButton.swift
//  Counters
//
//  Created by Lore P on 12/05/2023.
//

import SwiftUI

struct AddNewCounterButton: View {
  
  // MARK: - PROPERTIES
  @ObservedObject var viewModel: ViewModel
  
  @State private var isExpanded = false
  @State private var textFieldText = ""
  
  @FocusState private var isFocused
  
  
  // MARK: - BODY
  var body: some View {
    HStack {
      ZStack {
        // MARK: - Main Rect
        RoundedRectangle(cornerRadius: 20)
          .fill(.clear)
          .frame(width: 80, height: 60)
        Image(systemName: "xmark")
          .font(.system(size: 24, weight: .heavy))
          .foregroundColor(isExpanded ? .white : viewModel.accentColor)
          .rotationEffect(.degrees(isExpanded ? 0 : 315))
      }
      .background(isExpanded ? Color.red : viewModel.accentColor.opacity(0.1))
      .onTapGesture {
        isExpanded.toggle()
        isFocused.toggle()
      }
      
      // MARK: - TextField and Check
      if isExpanded {
        TextField("Enter a name", text: $textFieldText)
          .focused($isFocused)
          .onSubmit { addCounter() }
        
        Image(systemName: "checkmark")
          .foregroundColor(viewModel.accentColor)
          .bold()
          .padding(.trailing, 20)
          .onTapGesture { addCounter() }
      }
    }
    .background(.regularMaterial)
    .clipShape(RoundedRectangle(cornerRadius: 20))
    .animation(.spring(), value: isExpanded)
  }
  
  
  
  // MARK: - ACTIONS
  func addCounter() {
    viewModel.addCounter(name: textFieldText)
    viewModel.sortByDate()
    isExpanded = false
    textFieldText = ""
  }
}



// MARK: - PREVIEW
struct AddNewCounterButton_Previews: PreviewProvider {
    static var previews: some View {
        AddNewCounterButton(viewModel: ViewModel())
    }
}
