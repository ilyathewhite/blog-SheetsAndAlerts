//
//  DoneScreen.swift
//  Example
//
//  Created by Ilya Belenkiy on 11/22/25.
//

import AsyncNavigation

enum DoneScreen {
   class ViewModel: BaseViewModel<Void> {
      let address: Address

      init(address: Address) {
         self.address = address
      }
   }
}
