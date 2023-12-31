//
//  CloseButton.swift
//  Gametrack
//
//  Created by Ali Dinç on 21/12/2023.
//

import SwiftUI

struct CloseButton: View {
    
    @Environment(\.dismiss) private var dismiss
    var onDismiss: (() -> Void)?
    
    init(onDismiss: ( () -> Void)? = nil) {
        self.onDismiss = onDismiss
    }
    
    var body: some View {
        Button {
            dismiss()
            
            if let onDismiss {
                onDismiss()
            }
        } label: {
            Circle()
                        .fill(Color(.secondarySystemBackground))
                        .frame(width: 30, height: 30) // You can make this whatever size, but keep UX in mind.
                        .overlay(
                            Image(systemName: "xmark")
                                .font(.system(size: 15, weight: .bold, design: .rounded)) // This should be less than the frame of the circle
                                .foregroundColor(.secondary)
                        )
        }
        .padding()
    }
}