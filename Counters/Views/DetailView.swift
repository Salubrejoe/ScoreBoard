//
//  DetailView.swift
//  Counters
//
//  Created by Lore P on 10/05/2023.
//

import SwiftUI
import AVFoundation

struct DetailView: View {
  @Environment(\.dismiss) var dismiss
  
  // MARK: - PROPERTIES
  @ObservedObject var counter: CounterEntity
  @ObservedObject var viewModel: ViewModel
  
  @State private var isAdding = true
  @State private var audioPlayer: AVAudioPlayer?
  @State private var showingDeleteAlert = false
  
  
  var steps: [Int16] {
    var steps = [Int16]()
    for i in -100 ... 100 {
      steps.insert(Int16(i), at: 0)    }
    steps.remove(at: 100)
    return steps
  }
  
  // MARK: - BODY
  var body: some View {
    GeometryReader { geo in
      let screenWidth = geo.size.width
//      let screenHeight = geo.size.height
      
      ZStack {
        // MARK: - Background
        counter.background()
          .ignoresSafeArea()
        
        
        // CONTENT
        VStack {
          // MARK: - Header
          Header_DetailView(counter: counter, viewModel: viewModel)
            .padding(.horizontal)
          
          
          
          // MARK: - Count
          Text("\(counter.count)")
            .font(.system(size: 90))
          
          
          
          ZStack {
            
            
            // MARK: - Wheel Picker
            Picker("Number of steps", selection: $counter.numberOfSteps) {
              ForEach(steps, id: \.self) { number in
                
                if number < 0 {
                  Text("\(number)")
                } else {
                  Text("+\(number)")
                }
              }
            }
            .pickerStyle(.wheel)
            .offset(x: -screenWidth / 2 + screenWidth / 10)
            .frame(width: 68, height: 290)
            .onChange(of: counter.numberOfSteps) { newValue in
              if newValue < 0 {
                isAdding = false
              } else {
                isAdding = true
              }
            }
            
            
            // MARK: - Big Button
            Button{
              increment()
              playSound()
              viewModel.vibrate()
            } label: {
              Image(systemName: isAdding ? "chevron.up.square.fill" : "chevron.down.square.fill")
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .frame(maxWidth: screenWidth * 2 / 3, maxHeight: screenWidth * 2 / 3)
                .foregroundColor(.primary)
                .opacity(0.4)
                .shadow(radius: 5, y: 5)
            }
          }
          
          
          
          // MARK: - Small Button
          Button {
            subtract()
            viewModel.vibrate()
          } label: {
            Image(systemName: isAdding ? "chevron.down.square.fill" : "chevron.up.square.fill")
              .resizable()
              .aspectRatio(1, contentMode: .fit)
              .frame(maxWidth: 50, maxHeight: 50)
              .foregroundColor(.primary)
              .opacity(0.4)
              .shadow(radius: 5, y: 5)
          }
          .padding(.bottom, 20)
          .padding(.top, 12)
          
          Spacer()
        } // VStack
      } // ZStack
    }
  }
}

// MARK: - ACTIONS
extension DetailView {
  func deleteCounter() {
    if let index = viewModel.counters.firstIndex(where: { $0.id == counter.id }) {
      viewModel.deleteCounter(indexSet: IndexSet(integer: index))
    }
    dismiss()
  }
  
  func increment() {
    counter.count += counter.numberOfSteps
  }
  
  func subtract() {
    counter.count -= counter.numberOfSteps
  }
  
  func playSound() {
    let sound = Bundle.main.path(forResource: "beep", ofType: "mp3")!
    let url = URL(fileURLWithPath: sound)
    do {
      audioPlayer = try AVAudioPlayer(contentsOf: url)
    } catch {
      print("Unable to play sound")
    }
    if counter.soundIsOn {
      audioPlayer?.currentTime = 0
      audioPlayer?.play()
    }
  }
}



// MARK: - Preview
//struct DetailView_Previews: PreviewProvider {
//  static var previews: some View {
//    NavigationStack {
//      DetailView(
//        counter: .constant(CounterEntity()),
//        viewModel: ViewModel()
//      )
//    }
//  }
//}


