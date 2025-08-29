//
//  CircleView.swift
//  SwiftfulCrypto
//
//  Created by Alvaro Ordonez on 7/29/25.
//

import SwiftUI

struct CircleButtonView: View {
    
    let iconName: String
    
    var body: some View {
        Image(systemName: iconName)
            .font(.headline)
            .foregroundStyle(Color.theme.accentColor)
            .frame(width: 50, height: 50)
            .background(
                Circle()
                    .foregroundStyle(Color.theme.backgroundColor)
            )
            .shadow(
                color: Color.theme.accentColor.opacity(0.25),
                radius: 10, x: 0, y: 0)
            .padding()
    }
}

//on the canvas, make sure the "Selectable" mode is selected(the one with the arrow)
//.previewLayout(.sizeThatFits) no longer works
@available(iOS 17.0, *)
#Preview(traits: .sizeThatFitsLayout) {
    //we change the preview here because this isn't
    //going to be a full screen view, instead it will
    //be a small icon button
    Group {
        CircleButtonView(iconName: "info")
            .padding()
            //no need to add this color scheme as it's the default
            //.colorScheme(.light)
            //.previewLayout(.sizeThatFits)
        
        //to check dark mode, use .colorScheme(.dark)
        CircleButtonView(iconName: "plus")
            .padding()
            .colorScheme(.dark)
            //.previewLayout(.sizeThatFits)
    }
    
        
}
