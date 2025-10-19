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
    @StateObject private var authViewModel = AuthViewModel()
    // Inicializar Firebase cuando arranca la app
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
           WindowGroup {
               if let _ = authViewModel.user {
                   HomeView(vm: authViewModel)
               } else {
                   LoginView()
                       .environmentObject(authViewModel)
               }
           }
       }
}
