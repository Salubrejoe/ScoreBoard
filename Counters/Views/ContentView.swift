//
//  ContentView.swift
//  Counters
//
//  Created by Lore P on 10/05/2023.
//

import SwiftUI
import SwipeActions
import UniformTypeIdentifiers

struct ContentView: View {
  
  // MARK: - PROPERTIES
  @StateObject var viewModel = ViewModel()
  
  @State private var filtersConfDialogIsShowing = false
  @State private var draggedItem: CounterEntity?
  @State private var isShowingSettings = false
  
  
  
  // MARK: - BODY
  var body: some View {
    
    NavigationStack {
      ZStack(alignment: .bottom) {
        ScrollView {
          
            
            if !viewModel.counters.isEmpty {
              LazyVGrid(columns: viewModel.columns) {
                
              SwipeViewGroup {
                ForEach(viewModel.counters, id: \.id) { counter in
                  
                  // MARK: - List Item
                  ListItemView(counter: counter, viewModel: viewModel)
                    .onDrag {
                      draggedItem = counter
                      return NSItemProvider(item: nil, typeIdentifier: counter.name)
                    }
                    .onDrop(of: [UTType.text],
                            delegate: DragDropDelegate(
                              item: counter,
                              listData: $viewModel.counters,
                              current: $draggedItem
                            )
                    )
                }
              }// Swipe Group
              
            }// LazyVGrid
            
            } else {
          OnboardingView()
            .offset(y: 250)
        }
        }// ScrollView
        
        // MARK: - Add New Button
        AddNewCounterButton(viewModel: viewModel)
          .offset(y: isShowingSettings ? 100 : 0)
          .animation(.spring(), value: isShowingSettings)
          .padding()
        
      }// ZStack
      .navigationBarTitle("Scoreboard")
      .navigationBarTitleDisplayMode(.large)
      .animation(.spring(), value: viewModel.counters)
      .toolbar {
        
        // MARK: - Settings tbar
        ToolbarItem(placement: .navigationBarLeading) {
          Button(action: showSettings) {
            Image(systemName: "gearshape")
          }
        }
        
        // MARK: - Filters tbar
        ToolbarItem(placement: .navigationBarTrailing) {
          Button(action: showFilters){
            Image(systemName: "line.3.horizontal.decrease.circle")
          }
          .confirmationDialog("Filter", isPresented: $filtersConfDialogIsShowing) {
            Button("Title (A-Z)", action: viewModel.sortAZ)
            Button("Title (Z-A)", action: viewModel.sortZA)
            Button("Value (Low to High)", action: viewModel.sortCountAscending)
            Button("Value (High to Low)", action: viewModel.sortCountDescending)
            Button("Date created", action: viewModel.sortByDate)
            
            Button("Cancel", role: .cancel) {}
          }
          .onAppear {
            addExampleCounters()
          }
        }
      } // toolbar
      .onAppear { viewModel.fetchCounters() }
      
      // MARK: - Settings sheet
      .sheet(isPresented: $isShowingSettings) {
        SettingsView(viewModel: viewModel)
          .presentationDetents([.medium])
      }
    }
    .tint(viewModel.accentColor)
  }
}



// MARK: - ACTIONS
extension ContentView {
  
  func showSettings() {
    isShowingSettings.toggle()
  }

  func showFilters() {
    filtersConfDialogIsShowing.toggle()
  }
  
  func addExampleCounters() {
    viewModel.addCounter(name: "Tap to increment →")
    viewModel.addCounter(name: "Swipe to reveal options")
  }
}



// MARK: - PREVIEW
struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
