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
    }
    
    var body: some Scene {
        WindowGroup {
            if vm.user != nil {
                HomeView()
                    .environmentObject(vm)
            } else {
                LoginView()
                    .environmentObject(vm)
            }
        }
    }
}
