//
//  LoginView.swift
//  VaultEase
//
//  Created by ChristianCastro on 10/19/25.
//
import FirebaseAuth
import SwiftUI

struct LoginView: View {
    @StateObject private var vm = AuthViewModel()

    @State private var email = ""
    @State private var password = ""

    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Text("VaultEase 🔐")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                TextField("Correo electrónico", text: $email)
                    .textFieldStyle(.roundedBorder)
                    .autocapitalization(.none)

                SecureField("Contraseña", text: $password)
                    .textFieldStyle(.roundedBorder)

                Button("Iniciar sesión") {
                    Task {
                        await vm.signIn(email: email, password: password)
                    }
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)

                Button("Registrarme") {
                    Task {
                        await vm.signUp(email: email, password: password)
                    }
                }
                .buttonStyle(.bordered)

                Button("Iniciar sesión con Google") {
                    Task {
                        await vm.signInWithGoogle()
                    }
                }
                .buttonStyle(.bordered)

                if let user = vm.user {
                    Text("Sesión iniciada como \(user.email ?? "Sin correo")")
                        .foregroundColor(.green)
                    Button("Cerrar sesión") {
                        vm.signOut()
                    }
                }

                if let error = vm.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.caption)
                }
            }
            .padding()
        }
    }
}
