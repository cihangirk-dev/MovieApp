//
//  ProfileView.swift
//  MovieApp
//
//  Created by Cihangir Kankaya on 5.11.2025.
//

import SwiftUI

struct LoginView: View {
    
    private enum Field: Hashable {
        case email
        case password
    }
    @FocusState private var focusedField: Field?
    @ObservedObject var viewModel: AuthViewModel
    
    var onShowRegister: () -> Void
        
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
                VStack(spacing: 20) {
                    Spacer()
                        
                    Image("icon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                        .shadow(radius: 10)
                    
                    Text("Movie App")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                    
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
                            .foregroundColor(.red)
                            .font(.caption)
                            .multilineTextAlignment(.center)
                    }
                    
                    Button {
                        Task {
                            await viewModel.signIn()
                        }
                    } label: {
                        Text("Sign In")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.appSecondaryBlue)
                            .cornerRadius(10)
                    }
                    .disabled(viewModel.isLoading || viewModel.email.isEmpty || viewModel.password.isEmpty)
                    
                    Spacer()
                    Spacer()
                    
                    Button {
                        onShowRegister()
                    } label: {
                        HStack {
                            Text("Don't have an account?")
                                .foregroundStyle(.secondary)
                            Text("Sign Up")
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
    LoginView(viewModel: AuthViewModel(), onShowRegister: {})
}
