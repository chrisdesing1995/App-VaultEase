//
//  SignInWithGoogleUseCase.swift
//  VaultEase
//
//  Created by ChristianCastro on 10/19/25.
//

import Foundation
import FirebaseAuth

final class SignInWithGoogleUseCase {
    private let repository: AuthRepository

    init(repository: AuthRepository) {
        self.repository = repository
    }

    func execute() async throws -> User {
        return try await repository.signInWithGoogle()
    }
}
