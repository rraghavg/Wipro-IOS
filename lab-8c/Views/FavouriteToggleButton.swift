//
//  FavouriteToggleButton.swift
//  lab-8c
//
//  Created by Raghav Gupta
//  R3: Reusable child view demonstrating two-way @Binding state mutation
//

import SwiftUI

struct FavouriteToggleButton: View {
    // R3: Child view receives a two-way binding to state owned by the parent / view model
    @Binding var isFavourite: Bool

    var body: some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isFavourite.toggle()
            }
        } label: {
            HStack(spacing: 6) {
                Image(systemName: isFavourite ? "heart.fill" : "heart")
                    .foregroundColor(isFavourite ? .red : .gray)
                    .scaleEffect(isFavourite ? 1.15 : 1.0)

                Text(isFavourite ? "Favourited" : "Add to Favourites")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(isFavourite ? .red : .primary)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(isFavourite ? Color.red.opacity(0.12) : Color(.systemGray6))
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
