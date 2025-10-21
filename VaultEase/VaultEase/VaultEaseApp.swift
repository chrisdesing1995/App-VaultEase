//
//  VaultEaseApp.swift
//  VaultEase
//
//  Created by ChristianCastro on 10/19/25.
//

import SwiftUI
import FirebaseCore

@main
struct VaultEaseApp: App {
    @StateObject private var vm = AuthViewModel()
    
    init() {
        FirebaseApp.configure()
        print("✅ Firebase inicializado correctamente")
        if let clientID = FirebaseApp.app()?.options.clientID {
            print("CLIENT_ID encontrado: \(clientID)")
        } else {
            print("⚠️ CLIENT_ID no encontrado")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            if vm.user != nil {
                HomeView()
            } else {
                LoginView()
            }
        }
    }
}

