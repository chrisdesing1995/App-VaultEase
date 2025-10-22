//
//  LoginView.swift
//  VaultEase
//
//  Created by ChristianCastro on 10/19/25.
//

import SwiftUI
import FirebaseAuth
import GoogleSignIn

struct LoginView: View {
    @EnvironmentObject var vm: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var navigateToRegister = false
    @State private var navigateToHome = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                
                Spacer(minLength: 60)
                
                // MARK: - Title
                VStack(spacing: 8) {
                    Text("VaultEase 🔐")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.black)
                    
                    Text("Accede a tus credenciales de forma segura")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
                
                // MARK: - Inputs
                VStack(spacing: 18) {
                    CustomTextField(placeholder: "Correo electrónico", text: $email)
                    CustomSecureField(placeholder: "Contraseña", text: $password)
                }
                
                // MARK: - Forgot Password
                HStack {
                    Spacer()
                    Button("¿Olvidaste tu contraseña?") {
                        Task {
                            await vm.resetPassword(email: email)
                        }
                    }
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.red.opacity(0.8))
                }
                .padding(.horizontal, 4)
                
                // MARK: - Buttons
                VStack(spacing: 16) {
                    // Login
                    Button(action: {
                        Task {
                            await vm.signIn(email: email, password: password)
                            if vm.user != nil {
                                navigateToHome = true
                            }else {
                                navigateToHome = false
                            }
                        }
                    }) {
                        Text("Iniciar sesión")
                            .font(.system(size: 17, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    // Face ID
                    Button(action: {
                        // pendiente: FaceID
                    }) {
                        HStack {
                            Image(systemName: "faceid")
                                .font(.system(size: 20))
                            Text("Iniciar con Face ID")
                                .font(.system(size: 16, weight: .medium))
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.15))
                        .foregroundColor(.black)
                        .cornerRadius(10)
                    }
                    
                    // Divider
                    HStack {
                        Rectangle().frame(height: 1).foregroundColor(.gray.opacity(0.3))
                        Text("O")
                            .foregroundColor(.gray)
                            .font(.system(size: 14))
                        Rectangle().frame(height: 1).foregroundColor(.gray.opacity(0.3))
                    }
                    .padding(.vertical, 8)
                    
                    // Google Button
                    Button(action: {
                        Task {
                            await vm.signInWithGoogle()
                            if vm.user != nil {
                                navigateToHome = true
                            }
                        }
                    }) {
                        HStack {
                            Image(systemName: "globe")
                                .font(.system(size: 18))
                            Text("Iniciar sesión con Google")
                                .font(.system(size: 16, weight: .medium))
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                    }
                }
                
                // MARK: - Error Message
                if let error = vm.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.system(size: 14))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }

                Spacer()
                
                // MARK: - Footer
                HStack(spacing: 4) {
                    Text("¿No tienes una cuenta?")
                    Button("Regístrate") {
                        navigateToRegister = true
                    }
                    .foregroundColor(.blue)
                }
                .font(.system(size: 15))
                .padding(.bottom, 20)
            }
            .padding(.horizontal, 24)
            .navigationBarHidden(true)
            .navigationDestination(isPresented: $navigateToRegister) { RegisterView() }
            .navigationDestination(isPresented: $navigateToHome) { HomeView() }
        }
    }
}

