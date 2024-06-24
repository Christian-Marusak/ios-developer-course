//
//  LoginView.swift
//  Course App
//
//  Created by Christián on 02/06/2024.
//

import SwiftUI
// MARK: - User Interface of LoginView

struct LoginView: View {
    
    @StateObject private var store: LoginViewStore
    
    init(store: LoginViewStore) {
        _store = .init(wrappedValue: store)
    }
    
    var body: some View {
        Form {
            if store.state.status == .signUp {
                TextField("Name", text: $store.state.name)
            }
            TextField("Email", text: $store.state.email)
            SecureField("Password", text: $store.state.password)
            
            Button(store.state.buttonTitle) {
                store.send(.login)
            }
            
            Button("Change action") {
                store.send(.toggleStatus)
            }
        }
        .alert(
            store.state.error?.localizedDescription ?? "Error",
            isPresented: $store.state.showError
        ) {
            Button("OK", role: .cancel) {
                store.send(.hideError)
            }
        }
    }
}
