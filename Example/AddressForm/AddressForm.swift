//
//  AddressForm.swift
//  Example
//
//  Created by Ilya Belenkiy on 11/21/25.
//

import Foundation
import SwiftUI
import Combine
import AsyncNavigation

enum AddressForm {
   class ViewModel: BaseViewModel<Address> {
      struct Environment {
         let getShouldSaveFromUI: () async throws -> Bool
      }

      @Published var name = ""
      @Published var street = ""
      @Published var city = ""
      @Published var state = ""
      @Published var zip = ""

      var address: Address?
      var env: Environment?

      func update(with address: Address) {
         name = address.name
         street = address.street
         city = address.city
         state = address.state
         zip = address.zip
         self.address = address
      }

      func updateAddress() {
         guard !name.isEmpty, !street.isEmpty, !city.isEmpty, !state.isEmpty, !zip.isEmpty else {
            address = nil
            return
         }
         address = Address(name: name, street: street, city: city, state: state, zip: zip)
      }

      func binding<Value>(_ keyPath: ReferenceWritableKeyPath<ViewModel, Value>) -> Binding<Value> {
         Binding(
            get: {
               self[keyPath: keyPath]
            },
            set: {
               self[keyPath: keyPath] = $0
               self.updateAddress()
            }
         )
      }

      func done() {
         guard let address else { return }
         guard let env else { return }
         if Address.isSaved(address) {
            publish(address)
         }
         else {
            Task {
               guard let shouldSave = try? await env.getShouldSaveFromUI() else { return }
               if shouldSave {
                  Address.save(address)
               }
               publish(address)
            }
         }
      }
   }
}
