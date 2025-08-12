//
//  MenuItemView.swift
//  DesafioFrameworkNative
//
//  Created by Conrado Werlang on 12/08/25.
//

import SwiftUI

struct MenuItemView: View {
    let title: String

    var body: some View {
        HStack {
            Text(title.lowercased())
                .font(.system(size: 20))
                .foregroundColor(.secondary)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 10)
        .contentShape(Rectangle())
    }
}
