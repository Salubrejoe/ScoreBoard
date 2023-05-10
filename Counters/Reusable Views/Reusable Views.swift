//
//  Reusable Views.swift
//  Counters
//
//  Created by Lore P on 10/05/2023.
//

import SwiftUI



// MARK: - SQUARE COLOR PICKER
struct SquareColorPickerView: View {
  
  @Binding var colorValue: Color
  
  var body: some View {
    
    colorValue
      .frame(width: 20, height: 20, alignment: .center)
      .opacity(0.001)
      .overlay(Image(systemName: "paintpalette"))
      .padding(10)
      .overlay(ColorPicker("", selection: $colorValue, supportsOpacity: false).labelsHidden().opacity(0.015))
    
  }
}

// MARK: - ACCENT COLOR PICKER
struct CustomColorPicker: View {
  let colors: [Color] = systemColors
  @Binding var selectedColor: Color
  
  var body: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack(spacing: 10) {
        ForEach(colors, id: \.self) { color in
          color
            .frame(width: 30, height: 30)
            .cornerRadius(20)
            .onTapGesture {
              selectedColor = color
            }
        }
      }
      .padding()
    }
  }
}


// MARK: - CUSTOM SPACER
struct CustomSpacer: View {
  var height: CGFloat
  
  var body: some View {
    Rectangle()
      .fill(.clear)
      .frame(height: height)
  }
}
