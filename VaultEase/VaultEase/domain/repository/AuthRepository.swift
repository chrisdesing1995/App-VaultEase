//
//  AuthRepository.swift
//  VaultEase
//
//  Created by ChristianCastro on 10/19/25.
//

import Foundation
import FirebaseAuth

protocol AuthRepository {
    func signUp(email: String, password: String) async throws -> User
    func signIn(email: String, password: String) async throws -> User
    func signInWithGoogle() async throws -> User
    func signOut() throws
    func currentUser() -> User?
}
