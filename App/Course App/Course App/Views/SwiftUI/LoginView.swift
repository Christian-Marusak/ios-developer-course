//
//  LoginView.swift
//  Course App
//
//  Created by Christián on 02/06/2024.
//

import SwiftUI

import SwiftUI
import FirebaseAuth
// MARK: - User Interface of LoginView

struct LoginView: View {
    @State var register: Bool = true
//    var viewModel =
    
    
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
                text: "",
                title: "Email",
                placeholder: "Enter email"
            )
            InputView(
                text: "",
                title: "Password",
                placeholder: "Enter password",
                isSecureField: true
            )
            
            VStack {
                Button {
                    if register {
                        Task {
//                            await callCreateUser()
                        }
                    } else {
                        Task {
//                            await callLoginUser()
                        }
                        print("Login")
                    }
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


#Preview {
    LoginView()
}
