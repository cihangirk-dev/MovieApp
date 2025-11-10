//
//  RegisterView.swift
//  MovieApp
//
//  Created by Cihangir Kankaya on 5.11.2025.
//

import SwiftUI

struct RegisterView: View {
    
    private enum Field: Hashable {
        case fullName
        case email
        case password
    }
    @FocusState private var focusedField: Field?
    @ObservedObject var viewModel: AuthViewModel
    
    var onShowLogin: () -> Void
    
    var body: some View {
        ZStack {
            Color("appBackground")
                .ignoresSafeArea()
                .onTapGesture {
                    focusedField = nil
                }
            
            if viewModel.isLoading {
                ProgressView()
                    .scaleEffect(1.5)
            } else {
                
                VStack(spacing: 20){
                    Spacer()
                    
                    Image("icon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                        .shadow(radius: 10)
                    
                    Text("Create Account")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                    
                    TextField("Full Name", text: $viewModel.fullName)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                        .autocapitalization(.words)
                        .focused($focusedField, equals: .fullName)
                        .onSubmit {
                            focusedField = .email
                        }
                    TextField("Email", text: $viewModel.email)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .focused($focusedField, equals: .email)
                        .onSubmit {
                            focusedField = .password
                        }
                    
                    SecureField("Password", text: $viewModel.password)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                        .focused($focusedField, equals: .password)
                        .onSubmit {
                            focusedField = nil
                        }
                    
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundStyle(.red)
                            .font(.caption)
                            .multilineTextAlignment(.center)
                    }
                    
                    Button {
                        Task {
                            await viewModel.signUp()
                        }
                    }label: {
                        Text("Sign Up")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.appPrimaryRed)
                            .cornerRadius(10)
                    }
                    .disabled(viewModel.isLoading || viewModel.email.isEmpty || viewModel.password.isEmpty || viewModel.fullName.isEmpty)
                    
                    Spacer()
                    Spacer()
                    
                    Button {
                        onShowLogin()
                    }label: {
                        HStack {
                            Text("Already have an account?")
                                .foregroundStyle(.appSecondaryBlue)
                            Text("Sign In")
                                .fontWeight(.bold)
                                .foregroundStyle(.appPrimaryRed)
                        }
                    }
                }
                .padding()
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    RegisterView(viewModel: AuthViewModel(), onShowLogin: {})
}
