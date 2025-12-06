//
//  AddressFormUI.swift
//  Example
//
//  Created by Ilya Belenkiy on 11/21/25.
//

import SwiftUI
import AsyncNavigation

extension AddressForm: ViewModelUINamespace {
   struct ContentView: ViewModelContentView {
      @ObservedObject var viewModel: ViewModel
      @State private var shouldSaveAlertResult:
          CheckedContinuation<Bool, Error>? = nil

      var addressPickerUI: ViewModelUI<AddressPicker>? { .init(viewModel.child()) }

      init(_ viewModel: ViewModel) {
         self.viewModel = viewModel
      }

      var body: some View {
         NavigationStack {
            VStack {
               Form {
                  Section {
                     TextField("Name", text: viewModel.binding(\.name))
                     TextField("Street", text: viewModel.binding(\.street))
                     TextField("City", text: viewModel.binding(\.city))
                     HStack {
                        TextField("State", text: viewModel.binding(\.state))
                        TextField("ZIP", text: viewModel.binding(\.zip))
                           .keyboardType(.numbersAndPunctuation)
                     }
                  }
               }
               .navigationTitle("Addess")
               .toolbar {
                  ToolbarItem(placement: .cancellationAction) {
                     Button("Cancel") {
                        viewModel.cancel()
                     }
                  }
                  ToolbarItem(placement: .confirmationAction) {
                     Button("Done") {
                        viewModel.done()
                     }
                     .disabled(viewModel.address == nil)
                  }
               }
               Button("Use Recent") {
                  Task {
                     let addressPicker = AddressPicker.ViewModel()
                     if let address = try? await viewModel.run(addressPicker) {
                        viewModel.update(with: address)
                     }
                  }
               }
            }
         }
         .sheet(self, \.addressPickerUI) { ui in
            ui.makeView()
               .presentationDetents([.medium, .large])
         }
         .taskAlert(
            "Save Address?",
            $shouldSaveAlertResult,
            actions: { complete in
               Button("Yes, save") {
                   complete(true)
               }
               Button("No, use one time only") {
                   complete(false)
               }
            },
            message: {
               Text("Add the address to recent?")
            }
         )
         .onAppear { // set enn
            guard viewModel.env == nil else { return }
            viewModel.env = .init(
               getShouldSaveFromUI: {
                  return try await withCheckedThrowingContinuation { continuation in
                     shouldSaveAlertResult = continuation
                  }
               }
            )
         }
      }
   }
}

#Preview {
   AddressForm.ContentView(.init())
}
