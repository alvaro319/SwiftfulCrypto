//
//  CircleButtonAnimationView.swift
//  SwiftfulCrypto
//
//  Created by Alvaro Ordonez on 7/29/25.
//

import SwiftUI

struct CircleButtonAnimationView: View {
    
    //@State private var animate: Bool = false
    
    //@Binding means it is defined as an @State variable from where ever
    //this view is called and it cannot have a default value like
    //a @State var does. And @Binding can't be private
    @Binding var animate: Bool
    
    var body: some View {
        Circle()
            //shows only the outline of a circle with thickness of 5.0
            .stroke(lineWidth: 5.0)
            
            //scale will start at 0.0 when animate is false
            //scale will stop at 1.0 (or 100%)
            //A value of 0 scales the shape to have no size, 0.5 scales to half size in both dimensions, 2 scales to twice the regular size, and so on.
            .scale(animate ? 1.0 : 0.0)
            .opacity(animate ? 0.0 : 1.0)
            .animation(animate ? Animation.easeOut(duration: 1.0) : .none, value: animate)
        //initially used with:
        //@State private var animate: Bool = false
        //but changed this var to:
        //@Binding var animate: Bool
//            .onAppear {
//                animate.toggle()
//            }
    }
}

#Preview {
    //use .constant(bool) when using an @Binding var in a view
    CircleButtonAnimationView(animate: .constant(true))
        .foregroundStyle(.red)
        .frame(width: 100, height: 100)
}
