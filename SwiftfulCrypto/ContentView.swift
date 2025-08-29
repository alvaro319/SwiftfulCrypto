//
//  ContentView.swift
//  SwiftfulCrypto
//
//  Created by Alvaro Ordonez on 7/29/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            //uses our backgroundColor theme in assets folder
            Color.theme.backgroundColor.ignoresSafeArea()
            
            VStack(spacing: 40) {
                Text("Accent Color")
                    .foregroundStyle(Color.theme.accentColor)
                
                Text("Secondary Text Color")
                    .foregroundStyle(Color.theme.secondaryTextColor)
                
                Text("Red Color")
                    .foregroundStyle(Color.theme.redColor)
                
                Text("Green Color")
                    .foregroundStyle(Color.theme.greenColor)
            }
            .font(.headline)
            
        }
    }
}

#Preview {
    ContentView()
}
