//
//  AuthViewModel.swift
//  VaultEase
//
//  Created by ChristianCastro on 10/19/25.
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseCore

@MainActor
final class AuthViewModel: ObservableObject {
    @Published var user: User?
    @Published var errorMessage: String?

    private let signUpUseCase: SignUpUseCase
    private let signInUseCase: SignInUseCase
    private let signInWithGoogleUseCase: SignInWithGoogleUseCase
    private let repository: AuthRepository

    init(repository: AuthRepository = AuthRepositoryImpl()) {
        self.repository = repository
        self.signUpUseCase = SignUpUseCase(repository: repository)
        self.signInUseCase = SignInUseCase(repository: repository)
        self.signInWithGoogleUseCase = SignInWithGoogleUseCase(repository: repository)
        self.user = repository.currentUser()
    }

    func signUp(email: String, password: String) async {
        do {
            user = try await signUpUseCase.execute(email: email, password: password)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func signIn(email: String, password: String) async {
        do {
            user = try await signInUseCase.execute(email: email, password: password)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func signInWithGoogle() async {
        do {
            user = try await signInWithGoogleUseCase.execute()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func signOut() {
        do {
            try repository.signOut()
            user = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
