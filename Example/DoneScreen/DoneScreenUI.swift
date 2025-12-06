//
//  DoneScreenUI.swift
//  Example
//
//  Created by Ilya Belenkiy on 11/22/25.
//

import SwiftUI
import AsyncNavigation

extension DoneScreen: ViewModelUINamespace {
   struct ContentView: ViewModelContentView {
      @ObservedObject var viewModel: ViewModel

      init(_ viewModel: ViewModel) {
         self.viewModel = viewModel
      }

      var body: some View {
         VStack(spacing: 50) {
            Text("You entered")
               .font(.title)
            AddressView(address: viewModel.address)

            Button("Star Over") {
               viewModel.publish(())
            }
         }
      }
   }
}

#Preview {
   DoneScreen.ContentView(.init(address: .address1))
}
