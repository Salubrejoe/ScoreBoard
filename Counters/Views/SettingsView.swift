//
//  SettingsView.swift
//  Counters
//
//  Created by Lore P on 10/05/2023.
//

import SwiftUI

struct SettingsView: View {
  @Environment(\.dismiss) var dismiss
  
  // MARK: - PROPERTIES
  @ObservedObject var viewModel: ViewModel
  
  @State private var deleteAlertIsShowing = false
  @State private var resetAlertIsShowing = false
  @State private var colorAreShowing = false
  
  
  // MARK: - BODY
  var body: some View {
    NavigationStack {
      Form {
        
        Section {
          // MARK: - Vibration
          Toggle(isOn: $viewModel.isVibrating) {
            Label("Vibration", systemImage: "waveform.path")
          }
          HStack {
            
            // MARK: - Accent Color
            Button {
              colorAreShowing.toggle()
            } label: {
              Label {
                Text("Accent Color").foregroundColor(.primary)
              } icon: {
                Image(systemName: "paintbrush")
              }
            }
            
            Spacer()
            
            Image(systemName: colorAreShowing ? "chevron.down" : "chevron.right")
              .foregroundColor(.secondary)
          }
          if colorAreShowing {
            // MARK: - Color Picker
            CustomColorPicker(selectedColor: $viewModel.accentColor)
          }
        }
        
        Section {
          
          // MARK: - Reset all
          Button {
            showResetAlert()
          } label: {
            Label("Reset All", systemImage: "arrow.counterclockwise")
          }
          .alert("Reset all counters?", isPresented: $resetAlertIsShowing) {
            Button("Reset All") { resetAll() }
            Button("Cancel", role: .cancel) { }
          }
          
          // MARK: - Delete all
          Button {
            showDeleteAlert()
          } label: {
            Label("Delete All", systemImage: "trash")
              .foregroundColor(.red)
          }
          .alert("Are you sure you want to delete all counters?", isPresented: $deleteAlertIsShowing) {
            Button("Delete All", role: .destructive) { deleteAll() }
            Button("Cancel", role: .cancel) { }
          }
        }
      }// Form
      .navigationTitle("Settings")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        
        // MARK: - Toolbar
        ToolbarItem(placement: .navigationBarTrailing) {
          Button("Done", role: .cancel) {
            dismiss()
          }
        }
      }
    }
  }
  
  
  // MARK: - ACTIONS
  func showResetAlert() {
    resetAlertIsShowing.toggle()
  }
  
  func showDeleteAlert() {
    deleteAlertIsShowing.toggle()
  }
  
  func resetAll() {
    viewModel.resetAll()
    dismiss()
  }
  
  func deleteAll() {
    viewModel.deleteAll()
    dismiss()
  }
}


// MARK: - PREVIEW
struct SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationStack {
      SettingsView(viewModel: ViewModel())
    }
  }
}

