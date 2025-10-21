//
//  HomeView.swift
//  VaultEase
//
//  Created by ChristianCastro on 10/19/25.
//

import SwiftUI
import FirebaseAuth

struct HomeView: View {
    @StateObject private var vm = AuthViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("👋 Bienvenido, \(vm.user?.email ?? "Usuario")")
                    .font(.title2)
                    .padding(.top, 50)
                
                Button("Cerrar sesión") {
                    vm.signOut()
                }
                .font(.system(size: 17, weight: .medium))
                .foregroundColor(.red)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                
                Spacer()
            }
            .navigationTitle("Inicio")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
