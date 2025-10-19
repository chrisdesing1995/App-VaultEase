//
//  HomeView.swift
//  VaultEase
//
//  Created by ChristianCastro on 10/19/25.
//

import SwiftUI
import FirebaseAuth

struct HomeView: View {
    @ObservedObject var vm: AuthViewModel

    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Text("🏠 Bienvenido a VaultEase")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                if let email = vm.user?.email {
                    Text("Has iniciado sesión como:")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text(email)
                        .font(.headline)
                        .foregroundColor(.blue)
                }

                Button("Cerrar sesión") {
                    vm.signOut()
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)
            }
            .padding()
            .navigationTitle("Inicio")
        }
    }
}
