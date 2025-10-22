//
//  RegisterView.swift
//  VaultEase
//
//  Created by ChristianCastro on 10/21/25.
//


import SwiftUI
import FirebaseAuth

struct RegisterView: View {
    @EnvironmentObject var vm: AuthViewModel
    
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var navigateToLogin = false
    @State private var navigateToHome = false

    var body: some View {
        VStack(spacing: 30) {
            
            // MARK: - Header con botón atrás
            HStack {
                Button(action: { navigateToLogin = true }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.black)
                        .padding(8)
                        .background(Color.gray.opacity(0.1))
                        .clipShape(Circle())
                }
                Spacer()
            }
            .padding(.top, 16)
            
            Spacer(minLength: 20)
            
            // MARK: - Title
            VStack(spacing: 8) {
                Text("Crear cuenta 🔐")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.black)
                
                Text("Regístrate para comenzar a usar VaultEase")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            
            // MARK: - Inputs
            VStack(spacing: 18) {
                CustomTextField(placeholder: "Nombre completo", text: $name)
                CustomTextField(placeholder: "Correo electrónico", text: $email)
                CustomSecureField(placeholder: "Contraseña", text: $password)
                CustomSecureField(placeholder: "Confirmar contraseña", text: $confirmPassword)
            }
            
            // MARK: - Button
            VStack(spacing: 16) {
                Button(action: {
                    guard password == confirmPassword else {
                        vm.errorMessage = "Las contraseñas no coinciden"
                        return
                    }
                    Task {
                        await vm.signUp(email: email, password: password)
                        if vm.user != nil {
                            navigateToHome = true
                        }else{
                            navigateToHome = false
                        }
                    }
                }) {
                    Text("Registrarme")
                        .font(.system(size: 17, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                if let error = vm.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.system(size: 14))
                        .multilineTextAlignment(.center)
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
                        await vm.signUpWithGoogle()
                        if vm.user != nil {
                            if Auth.auth().currentUser?.metadata.creationDate == Auth.auth().currentUser?.metadata.lastSignInDate {
                                print("🆕 Registro completado")
                            }
                            navigateToHome = true
                        }
                    }
                }) {
                    HStack {
                        Image(systemName: "globe")
                            .font(.system(size: 18))
                        Text("Registrarse con Google")
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

            Spacer()
            
            // MARK: - Footer
            HStack(spacing: 4) {
                Text("¿Ya tienes una cuenta?")
                Button("Inicia sesión") {
                    navigateToLogin = true
                }
                .foregroundColor(.blue)
            }
            .font(.system(size: 15))
            .padding(.bottom, 20)
            
        }
        .padding(.horizontal, 24)
        .navigationBarHidden(true)
        .navigationDestination(isPresented: $navigateToLogin) { LoginView() }
        .navigationDestination(isPresented: $navigateToHome) { HomeView() }
    }
}
