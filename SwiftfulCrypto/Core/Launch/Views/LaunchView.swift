//
//  LaunchView.swift
//  SwiftfulCrypto
//
//  Created by Alvaro Ordonez on 8/27/25.
//

import SwiftUI

struct LaunchView: View {
    
//    @State private var loadingText: String = "Loading your portfolio..."
    //to animate each string, map a single string into an array of strings, placing one char into an array of single char strings.
    @State private var loadingText: [String] = "Loading your portfolio...".map {String($0)}
    
    @State private var showLoadingText: Bool = false
    //start the timer as soon as the view loads
    private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State private var counter: Int = 0
    @State private var numLoops: Int = 0
    @Binding var showLaunchView: Bool
    
    var body: some View {
        
        ZStack {
            Color.launch.backgroundColor
                .ignoresSafeArea()
            Image("logo-transparent")
                .resizable()
                .frame(width: 100, height: 100)
            
            ZStack {
                if showLoadingText {
                    //brings the spacing to 0 between each letter
                    HStack(spacing: 0) {
                        ForEach(loadingText.indices, id: \.self) { index in
                            Text(loadingText[index])
                                .font(.headline)
                                .fontWeight(.heavy)
                                .foregroundStyle(Color.launch.accentColor)
                                .offset(y: counter == index ? -5 : 0)
                        }
                    }
                    .transition(AnyTransition.scale.animation(.easeIn))
                    
                    //original code for animation
                    /*
                    Text(loadingText)
                        .font(.headline)
                        .fontWeight(.heavy)
                        .foregroundStyle(Color.launch.accentColor)
                        .transition(AnyTransition.scale.animation(.easeIn))
                     */
                }
            }
            .offset(y: 70)
        }
        .onAppear {
            showLoadingText.toggle()
        }
        //don't do anything with incoming time value
        .onReceive(timer) { _ in
            
            let lastIndex = loadingText.count - 1
            if counter == lastIndex {
                counter = 0
                numLoops += 1
                
                if numLoops >= 2 {
                    showLaunchView = false
                }
            } else {
                counter += 1
            }
        }
    }
}

#Preview {
    LaunchView(showLaunchView: .constant(true))
}
