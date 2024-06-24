//
//  LoginViewStore.swift
//  Course App
//
//  Created by Christián on 22/06/2024.
//

import Combine
import os

enum LoginEvent {
    case login
}

struct LoginViewState {
    
    enum Status {
        case signIn, signUp
        
        func toggle() -> Status {
            self == .signIn ? .signUp : .signIn
        }
    }
    
    var status: Status
    var email: String = ""
    var password: String = ""
    var name: String = ""
    var error: Error?
    var showError: Bool = false
    
    var buttonTitle: String {
        status == .signIn ? "Sign in" : "Sign up"
    }
}

enum LoginViewAction {
    case toggleStatus
    case login
    case hideError
    case showError(Error)
}

final class LoginViewStore: Store {
    
    @MainActor
    @Published var state: LoginViewState = LoginViewState(status: .signIn)
    
    private let authManager: FirebaseAuthManaging
    private let storeManager: StoreManaging
    private let eventSubject = PassthroughSubject<LoginEvent, Never>()
    private let logger = Logger()
    
    init(authManager: FirebaseAuthManaging, storeManager: StoreManaging) {
        self.authManager = authManager
        self.storeManager = storeManager
    }
    
    @MainActor
    func send(_ action: LoginViewAction) {
        switch action {
        case .login:
            login()
        case .toggleStatus:
            state.status = state.status.toggle()
        case .hideError:
            state.showError = false
        case let .showError(error):
            state.error = error
            state.showError = true
        }
    }
}

extension LoginViewStore {
    func login() {
        Task {
            do {
                switch await state.status {
                case .signIn:
                    try await signIn()
                case  .signUp:
                    try await signUp()
                }
                DispatchQueue.main.async {
                    self.eventSubject.send(.login)
                }
            } catch {
                logger.error("Error: \(error.localizedDescription)")
                await send(.showError(error))
            }
        }
    }
    
    private func signIn() async throws {
        try await authManager.signIn(Credentials(email: state.email, password: state.password))
    }
    
    private func signUp() async throws {
        try await authManager.signUp(Credentials(email: state.email, password: state.password))
        try await storeManager.store(userDetails: UserDetails(name: state.name))
    }
}

extension LoginViewStore: EventEmitting {
    var eventPublisher: AnyPublisher<LoginEvent, Never> {
        eventSubject.eraseToAnyPublisher()
    }
}
