//
//  OnboardingView.swift
//  Counters
//
//  Created by Lore P on 12/05/2023.
//

import SwiftUI

struct OnboardingView: View {
  
  @State private var offsetY: CGFloat = 0
  @State private var opacity: Double = 0.1
  
  var body: some View {
    VStack {
      Text("Tap the + button to start")
        .font(.subheadline)
        .foregroundColor(.secondary)
      
      Image(systemName: "arrow.down")
        .font(.largeTitle)
        .foregroundColor(.secondary)
        .padding(.top, 40)
        .offset(y: offsetY)
        .opacity(opacity)
        .animation(
          Animation.linear(duration: 2.0)
            .repeatForever(autoreverses: false)
        , value: offsetY)
        .onAppear {
          self.offsetY = 100
          self.opacity = 1
        }
    }
  }
}

struct OnboardingView_Previews: PreviewProvider {
  static var previews: some View {
    OnboardingView()
  }
}
