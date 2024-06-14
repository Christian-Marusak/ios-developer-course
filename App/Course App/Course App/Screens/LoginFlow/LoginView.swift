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
    
    enum Action {
        case signIn, signUp
        
        func toggle() -> Action {
            self == .signIn ? .signUp : .signIn
        }
    }
    
    enum LoginEvent {
        case login
    }
    
    @State private var email: String
    @State private var password: String
    @State private var action: Action = .signIn
    private let authManager = FirebaseAuthManager()
    private let eventSubject = PassthroughSubject<LoginEvent, Never>()

    init(email: String = "", password: String = "") {
        self.email = email
        self.password = password
    }

    var body: some View {
        Form {
            TextField("Email", text: $email)
            SecureField("Password", text: $password)

            Button((action == .signIn ? "Sign in" : "Sign up")) {
                signIn()
            }
            
            Button("Change action") {
                action = action.toggle()
            }
        }
    }
}

private extension LoginView {
    @MainActor
    func signIn() {
        Task {
            do {
                switch action {
                case .signIn:
                    try await authManager.signIn(Credentials(email: email, password: password))
                case  .signUp:
                    try await authManager.signUp(Credentials(email: email, password: password))
                }
                eventSubject.send(.login)
            } catch {
                print(error)
            }
        }
    }
}

// MARK: - EventEmitting
extension LoginView: EventEmitting {
    var eventPublisher: AnyPublisher<LoginEvent, Never> {
        eventSubject.eraseToAnyPublisher()
    }
}

#Preview {
    LoginView(email: "email@email.com", password: "password")
}


//struct LoginView: View {
//    
//    enum LoginEvent {
//        case login
//    }
//    
//    private let eventSubject = PassthroughSubject<LoginEvent, Never>()
//    @State var register: Bool = true
////    var viewModel =
//    
//    
//    var body: some View {
//        Text("Welcome to our Course App")
//            .textTypeModifier(textType: .h1Title)
//            .padding(.top)
//        Spacer()
//        VStack {
//            InputView(
//                text: "",
//                title: "Name",
//                placeholder: "Enter you name"
//            )
//            .opacity(register ? 1 : 0)
//            .animation(.easeIn, value: register)
//            
//            InputView(
//                text: "",
//                title: "Email",
//                placeholder: "Enter email"
//            )
//            InputView(
//                text: "",
//                title: "Password",
//                placeholder: "Enter password",
//                isSecureField: true
//            )
//            
//            VStack {
//                Button {
////                    if register {
////                        Task {
//////                            await callCreateUser()
////                        }
////                    } else {
////                        Task {
//////                            await callLoginUser()
////                        }
////                        print("Login")
////                    }
//                    eventSubject.send(.login)
//                    UserDefaults.standard.set(true, forKey: Constants.isAuthorizedFlowKey)
//                } label: {
//                    Text(register ? "register" : "login")
//                        .animation(.easeIn, value: register)
//                        .frame(width: 100, height: 40)
//                        .cornerRadius(15)
//                    
//                }
//                Button {
//                    register.toggle()
//                }label: {
//                    HStack {
//                        Text(register ? "i have account i want to" : "I dont have account i want to")
//                            .font(.footnote)
//                        Text(register ? "login" : "register")
//                            .font(.footnote)
//                            .bold()
//                    }
//                }
//            }
//            .padding(50)
//        }
//        .padding()
//        Spacer()
//        
//    }
//}
//
//extension LoginView: EventEmitting {
//    var eventPublisher: AnyPublisher<LoginEvent, Never> {
//        eventSubject.eraseToAnyPublisher()
//    }
//}
//
//
//#Preview {
//    LoginView()
//}
