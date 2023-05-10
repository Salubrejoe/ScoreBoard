//
//  ListItemView.swift
//  Counters
//
//  Created by Lore P on 10/05/2023.
//

import SwiftUI
import AVFoundation
import SwipeActions
import Combine


struct ListItemView: View {
  
  // MARK: - PROPERTIES
  @ObservedObject var counter: CounterEntity
  @ObservedObject var viewModel: ViewModel
  
  @State private var audioPlayer: AVAudioPlayer?
  @State private var showingDeleteAlert = false
  @State private var isShowingDetailView = false
  @State private var showingResetAlert = false
  
  
  // MARK: - BODY
  var body: some View {
    
    SwipeView {
      ZStack {
        
        // MARK: - Background
        RoundedRectangle(cornerRadius: 16)
          .fill(counter.background())
          
        
        HStack {
          
          // LEFTMOST PART
          VStack(alignment: .leading, spacing: 6) {
            
            // MARK: - Counter Name
            Text(counter.name ?? "")
              .font(.headline)
              .foregroundColor(.primary)
            HStack {
              
              // MARK: - Icons
              Text("\(counter.formattedNumberOfSteps)")
              Button(action: toggleVolume){
                Image(systemName: counter.soundIsOn ? "speaker.wave.2.fill" : "speaker.slash.fill")
              }
            }// HStack
            .font(.subheadline)
            .foregroundColor(.secondary)
          }// VStack
          
          Spacer()
          
          
          // MARK: - Tappable count
          Text("\(counter.count)")
            .font(.system(size: 44))
            .foregroundColor(.primary)
            .frame(minWidth: 80)
            .background(viewModel.accentColor.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .onTapGesture {
              playSound()
              viewModel.vibrate()
              incrementCounter()
            }
            .padding(.horizontal, 12)
          
        }//: HStack
        .padding(.leading)
        
      }//: ZStack
      .frame(height: 70)
      
      
      // MARK: - Swipe Actions:
    } leadingActions: { context in
      
      
      // MARK: - Toggle sound
      SwipeAction(systemImage: counter.soundIsOn ? "speaker.wave.2.fill" : "speaker.slash.fill") {
        toggleVolume()
        context.state.wrappedValue = .closed
      }
      .font(.headline)
      
      // MARK: - Random Color
      SwipeAction(systemImage: "paintbrush") {
        randomizeCounterColor()
      }
      .font(.headline)
      
      
    } trailingActions: { context in
      
      // MARK: - Reset
      SwipeAction("Reset") {
        showingResetAlert.toggle()
        context.state.wrappedValue = .closed // Close Action
      }
      .alert("Reset counter?", isPresented: $showingResetAlert) {
        Button("Reset") { resetCounter() }
        Button("Cancel", role: .cancel) {}
      }
      .font(.headline)
      
      // MARK: - Delete
      SwipeAction(systemImage: "trash") {
        showingDeleteAlert.toggle()
        context.state.wrappedValue = .closed
      }
      .alert("Delete counter?", isPresented: $showingDeleteAlert) {
        Button("Delete", role: .destructive) { deleteCounter() }
        Button("Cancel", role: .cancel) { }
      }
      .font(.headline)
      .foregroundColor(.white)
      .background(Color.red)
      
    }
    .swipeActionCornerRadius(12)
    .padding(.horizontal)
    
    // MARK: - Sheet Presented
    .onTapGesture { isShowingDetailView.toggle() }
    .sheet(isPresented: $isShowingDetailView) {
      DetailView(counter: counter, viewModel: viewModel)
    }
  }
}


// MARK: - ACTIONS
extension ListItemView {
  func randomizeCounterColor() {
    
    let uiColor = UIColor(goodColors.randomElement() ?? Color.black)
    let red = uiColor.cgColor.components?[0] ?? 0
    let green = uiColor.cgColor.components?[1] ?? 0
    let blue = uiColor.cgColor.components?[2] ?? 0
    
    counter.red = red
    counter.green = green
    counter.blue = blue
    
    viewModel.saveCounters()
  }
  
  func resetCounter() {
    counter.count = 0
    counter.numberOfSteps = 1
  }
  
  func deleteCounter() {
    if let index = viewModel.counters.firstIndex(where: { $0.id == counter.id }) {
      viewModel.deleteCounter(indexSet: IndexSet(integer: index))
    }
  }
  
  func toggleVolume() {
    counter.soundIsOn.toggle()
  }
  
  func incrementCounter() {
    counter.count += counter.numberOfSteps
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
//struct ListItemView_Previews: PreviewProvider {
//  static let counterTest = CounterEntity()
//  
//  static var previews: some View {
//    ListItemView(counter: .constant(counterTest), viewModel: ViewModel())
//      .previewLayout(.sizeThatFits)
//  }
//}
