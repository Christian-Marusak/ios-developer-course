//
//  LoginView.swift
//  Course App
//
//  Created by Christián on 02/06/2024.
//

import SwiftUI
import Combine
import FirebaseAuth
// MARK: - User Interface of LoginView

struct LoginView: View {
    
    private let eventSubject = PassthroughSubject<LoginEvent, Never>()
    @State private var register: Bool = true
    @State private var password: String
    @State var email: String
    private let authManager = FirebaseAuthManager()
    
    init(password: String  = "", email: String = "") {
        self.password = password
        self.email = email
    }
    
    enum LoginEvent {
        case login
    }
    
    
    var body: some View {
        Text("Welcome to our Course App")
            .textTypeModifier(textType: .h1Title)
            .padding(.top)
        Spacer()
        VStack {
            InputView(
                text: "",
                title: "Name",
                placeholder: "Enter you name"
            )
            .opacity(register ? 1 : 0)
            .animation(.easeIn, value: register)
            
            InputView(
                text: email,
                title: "Email",
                placeholder: "Enter email"
            )
            InputView(
                text: password,
                title: "Password",
                placeholder: "Enter password",
                isSecureField: true
            )
            
            VStack {
                Button {
                    signIn()
                    UserDefaults.standard.set(true, forKey: Constants.isAuthorizedFlowKey)
                } label: {
                    Text(register ? "register" : "login")
                        .animation(.easeIn, value: register)
                        .frame(width: 100, height: 40)
                        .cornerRadius(15)
                    
                }
                Button {
                    register.toggle()
                }label: {
                    HStack {
                        Text(register ? "i have account i want to" : "I dont have account i want to")
                            .font(.footnote)
                        Text(register ? "login" : "register")
                            .font(.footnote)
                            .bold()
                    }
                }
            }
            .padding(50)
        }
        .padding()
        Spacer()
        
    }
}
extension LoginView {
    
    @MainActor
    func signIn() {
        Task {
            do {
                try await authManager.signIn(Credentials(email: email, password: password))
                eventSubject.send(.login)
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
}

extension LoginView: EventEmitting {
    var eventPublisher: AnyPublisher<LoginEvent, Never> {
        eventSubject.eraseToAnyPublisher()
    }
}


#Preview {
    LoginView()
}
