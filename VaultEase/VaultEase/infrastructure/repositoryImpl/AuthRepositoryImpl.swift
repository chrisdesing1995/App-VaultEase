//
//  AuthService.swift
//  VaultEase
//
//  Created by ChristianCastro on 10/19/25.
//

import Foundation
import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import UIKit

final class AuthRepositoryImpl : AuthRepository{

    func signUp(email: String, password: String) async throws -> User {
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        return result.user
    }

    func signIn(email: String, password: String) async throws -> User {
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        return result.user
    }

    func signInWithGoogle() async throws -> User {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            throw NSError(domain: "FirebaseAuthRepository", code: -1, userInfo: [NSLocalizedDescriptionKey: "Client ID missing"])
        }

        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootVC = windowScene.windows.first?.rootViewController else {
            throw NSError(domain: "FirebaseAuthRepository", code: -2, userInfo: [NSLocalizedDescriptionKey: "No root view controller found"])
        }

        return try await withCheckedThrowingContinuation { continuation in
            GIDSignIn.sharedInstance.signIn(withPresenting: rootVC) { result, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }

                guard let user = result?.user,
                      let idToken = user.idToken?.tokenString else {
                    continuation.resume(throwing: NSError(domain: "FirebaseAuthRepository", code: -3, userInfo: [NSLocalizedDescriptionKey: "Google Sign-In failed"]))
                    return
                }

                let credential = GoogleAuthProvider.credential(
                    withIDToken: idToken,
                    accessToken: user.accessToken.tokenString
                )

                Auth.auth().signIn(with: credential) { authResult, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                    } else if let user = authResult?.user {
                        continuation.resume(returning: user)
                    }
                }
            }
        }
    }


    func signOut() throws {
        try Auth.auth().signOut()
        GIDSignIn.sharedInstance.signOut()
    }

    func currentUser() -> User? {
        Auth.auth().currentUser
    }
}
