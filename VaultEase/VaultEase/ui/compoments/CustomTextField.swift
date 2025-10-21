//
//  CustomTextField.swift
//  VaultEase
//
//  Created by ChristianCastro on 10/21/25.
//

import SwiftUI

struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    
    var body: some View {
        TextField(placeholder, text: $text)
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            .textInputAutocapitalization(.never)
            .disableAutocorrection(true)
    }
}
