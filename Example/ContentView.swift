//
//  ContentView.swift
//  Example
//
//  Created by Ilya Belenkiy on 11/21/25.
//

import SwiftUI
import AsyncNavigation

struct ContentView: View {
   func done(address: Address, _ proxy: NavigationProxy) -> NavigationNode<DoneScreen> {
      .init(DoneScreen.ViewModel(address: address), proxy)
   }

    func addressForm() -> RootNavigationNode<AddressForm> {
        .init(AddressForm.ViewModel())
    }

   var body: some View {
      NavigationFlow(addressForm()) { address, proxy in
         await done(address: address, proxy).then { _, _ in
            proxy.popToRoot()
         }
      }
   }
}

#Preview {
   ContentView()
}
