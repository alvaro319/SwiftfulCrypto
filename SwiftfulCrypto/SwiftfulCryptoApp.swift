//
//  SwiftfulCryptoApp.swift
//  SwiftfulCrypto
//
//  Created by Alvaro Ordonez on 7/29/25.
//

import SwiftUI

@main
struct SwiftfulCryptoApp: App {
    
    @StateObject private var viewModel: HomeViewModel = HomeViewModel()
    @State private var showLaunchView = true
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor : UIColor(Color.theme.accentColor)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor(Color.theme.accentColor)]
        //makes all UITableViews and therefore all List rows clear
        //a list derives from a TableView, therefore, all the
        //lists, by default, will have a background that is clear
        UITableView.appearance().backgroundColor = UIColor.clear
    }
    
    var body: some Scene {
        WindowGroup {
            
            //placed navigation view in a Zstack
            //placed HomeView() first with
            //Launch View on top
            ZStack {
                //ContentView()
                NavigationView {
                    HomeView()
                        //we are building our own header at the top
                        //of the HomeView so we don't want to use
                        //the Navigation View's default Navigation bar
                        .navigationBarHidden(true)//will be deprecated in future
                }
                //forces iPad to have same NavigationStyling as the iPhone
                .navigationViewStyle(StackNavigationViewStyle())
                //for iOS 16 or newer(use this
                //when .navigationBarHidden(bool) deprecates
                //.toolbar(.hidden, for: .navigationBar)
                
                //all children views has access to this viewModel
                .environmentObject(viewModel)
                
                //This ZStack makes sure that this LaunchView is always on top
                //of the HomeView()
                ZStack {
                    if showLaunchView {
                        LaunchView(showLaunchView: $showLaunchView)
                            //animates off the screen to the left hand side
                            .transition(.move(edge: .leading))
                    }
                }
                .zIndex(2.0)
            }
            
        }
    }
}
