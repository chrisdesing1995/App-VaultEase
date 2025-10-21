//
//  AuthViewModel.swift
//  VaultEase
//
//  Created by ChristianCastro on 10/21/25.
//

import SwiftUI
import Combine
import FirebaseAuth
import GoogleSignIn
import FirebaseCore

@MainActor
final class AuthViewModel: ObservableObject {
    @Published var user: User?
    @Published var errorMessage: String?
    @Published var isLoading = false
    
    init() {
        self.user = Auth.auth().currentUser
    }
    
    // MARK: - Registro con email y contraseña
    func signUp(email: String, password: String) async {
        do {
            isLoading = true
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.user = result.user
            print("✅ Usuario registrado: \(result.user.email ?? "")")
        } catch {
            self.errorMessage = mapFirebaseError(error)
        }
        isLoading = false
    }
    
    // MARK: - Inicio de sesión con email
    func signIn(email: String, password: String) async {
        do {
            isLoading = true
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.user = result.user
            print("✅ Sesión iniciada: \(result.user.email ?? "")")
        } catch {
            self.errorMessage = mapFirebaseError(error)
        }
        isLoading = false
    }
    
    // MARK: - Cierre de sesión
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.user = nil
            print("👋 Sesión cerrada")
        } catch {
            self.errorMessage = "No se pudo cerrar sesión"
        }
    }
    
    // MARK: - Restablecer contraseña
    func resetPassword(email: String) async {
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
            errorMessage = "📧 Se ha enviado un enlace para restablecer tu contraseña."
        } catch {
            errorMessage = mapFirebaseError(error)
        }
    }
    
    // MARK: - Inicio de sesión o registro con Google
    func signUpWithGoogle() async {
        await signInWithGoogle()
    }

    
    func signInWithGoogle() async {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            errorMessage = "Client ID faltante en configuración Firebase"
            return
        }

        do {
            // Obtener la vista raíz actual
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let rootVC = windowScene.windows.first?.rootViewController else {
                errorMessage = "No se encontró la vista raíz para Google Sign-In"
                return
            }

            // Configuración de Google Sign-In
            let config = GIDConfiguration(clientID: clientID)
            GIDSignIn.sharedInstance.configuration = config

            // Presentar el flujo de Google Sign-In
            let result: GIDSignInResult = try await withCheckedThrowingContinuation { continuation in
                GIDSignIn.sharedInstance.signIn(withPresenting: rootVC) { signInResult, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                    } else if let signInResult = signInResult {
                        continuation.resume(returning: signInResult)
                    }
                }
            }

            // Obtener credenciales
            guard let idToken = result.user.idToken?.tokenString else {
                errorMessage = "Error obteniendo token de Google"
                return
            }

            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: result.user.accessToken.tokenString
            )

            // Iniciar sesión (o registrar si es nuevo)
            let authResult = try await Auth.auth().signIn(with: credential)
            self.user = authResult.user

            print("✅ Sesión iniciada o usuario registrado con Google: \(authResult.user.email ?? "")")

        } catch {
            errorMessage = mapFirebaseError(error)
        }
    }

    // MARK: - Manejo de errores de Firebase
    private func mapFirebaseError(_ error: Error) -> String {
        let nsError = error as NSError
        switch AuthErrorCode(rawValue: nsError.code) {
        case .emailAlreadyInUse:
            return "El correo ya está en uso"
        case .invalidEmail:
            return "Correo electrónico no válido"
        case .wrongPassword:
            return "Contraseña incorrecta"
        case .userNotFound:
            return "Usuario no encontrado"
        case .weakPassword:
            return "La contraseña es demasiado débil"
        default:
            return nsError.localizedDescription
        }
    }
}

