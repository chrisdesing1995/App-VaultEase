//
//  SignUpUseCase.swift
//  VaultEase
//
//  Created by ChristianCastro on 10/19/25.
//

import Foundation
import FirebaseAuth

final class SignUpUseCase {
    private let repository: AuthRepository

    init(repository: AuthRepository) {
        self.repository = repository
    }

    func execute(email: String, password: String) async throws -> User {
        return try await repository.signUp(email: email, password: password)
    }
}
