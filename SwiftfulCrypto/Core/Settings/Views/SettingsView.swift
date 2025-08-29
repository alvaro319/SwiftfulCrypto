//
//  SettingsView.swift
//  SwiftfulCrypto
//
//  Created by Alvaro Ordonez on 8/26/25.
//

import SwiftUI

//Important Note!
/*
 This view will be opened as a sheet. When opening a view as a sheet,
 the view is opened in a new environment, just like the PortfolioView.
 Because this view is in a new environment, it is no longer in the NavigationView that was created in the SwiftfulCryptoApp.swift file.
 We must embed it in a NavigationView
 */

//we could create a ViewModel for this view
struct SettingsView: View {
    
    @Environment(\.dismiss) var dismiss
    //hard coding these URLs but for brevity, we force unwrap
    let defaultURL = URL(string: "https://www.google.com")!
    let youtubeURL = URL(string: "https://www.youtube.com")!
    let coffeeURL = URL(string: "https://www.youtube.com")!
    let coingeckoURL = URL(string: "https://www.coingecko.com")!
    let personalURL = URL(string: "https://github.com/alvaro319")!
    
    var body: some View {
        NavigationView {
            ZStack {
                
                //background
                Color.theme.backgroundColor
                    .ignoresSafeArea()
                
                //content
                //sample Header/Footer with section
                /*
                List {
                    Section {
                        Text("Hi")
                        Text("Hi")
                    } header: {
                        Text("Header")
                    } footer: {
                        Text("Footer")
                    }
                }
                 */
                List {
                    swiftfulThinkingSection
                        .listRowBackground(Color.theme.backgroundColor.opacity(0.2))
                    coinGeckoSection
                        .listRowBackground(Color.theme.backgroundColor.opacity(0.2))
                    developerSection
                        .listRowBackground(Color.theme.backgroundColor.opacity(0.2))
                    applicationSection
                        .listRowBackground(Color.theme.backgroundColor.opacity(0.2))
                }
            }
            //in order for the background of the Navigation Title and list sections to look uniform with the same background color as the list sections themselves, use this call to .scrollContentBackground(.hidden) and the .listRowBackground above
            .scrollContentBackground(.hidden)
            .font(.headline)
            //only makes links blue, the other texts are overwritten in their local
            //closures
            .foregroundStyle(Color.blue)
            .listStyle(GroupedListStyle())
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    XMarkButton(dismiss: _dismiss)
                }
                
            }
        }
    }
}

extension SettingsView {
    
    private var swiftfulThinkingSection : some View {
        
        Section {
            VStackLayout(alignment: .leading) {
                //in assets folder
                Image("logo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("This app was made by following a @SwiftfulThinking course on Youtube. It uses MVVM Architecture, Combine, and CoreData!")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.theme.accentColor)
            }
            .padding(.vertical)
            //control-cmd-spacebar for emoji insertion
            Link("Subscribe on Youtube 🥳", destination: youtubeURL)
            Link("Support Coffee Addiction ☕️", destination: coffeeURL)
        } header: {
            Text("Swiftful Thinking")
                .foregroundStyle(Color.theme.accentColor)
        }
        
    }
    
    private var coinGeckoSection : some View {
        Section {
            VStackLayout(alignment: .leading) {
                //in assets folder
                //coingecko image is elongated so needed to adjust the modifiers for  image
                Image("coingecko")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("The cryptocurrency data that is used in this app comes from a free API from CoinGeck! Prices may be slightly delayed.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.theme.accentColor)
            }
            .padding(.vertical)
            //control-cmd-spacebar for emoji insertion
            Link("Visit CoinGecko 🦎", destination: coingeckoURL)
        } header: {
            Text("CoinGecko")
                .foregroundStyle(Color.theme.accentColor)
        }
    }
    
    private var developerSection : some View {
        
        Section {
            VStackLayout(alignment: .leading) {
                //in assets folder
                //coingecko image is elongated so needed to adjust the modifiers for this image
                Image("logo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("This app was created by Alvaro Ordonez. It uses SwiftUI and is written 100% in Swift. The project benefits from multi-threading, publishers/subscribers, and data persistance (CoreData).")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.theme.accentColor)
            }
            .padding(.vertical)
            //control-cmd-spacebar for emoji insertion
            Link("Visit Github Page", destination: personalURL)
        } header: {
            Text("Developer Section")
                .foregroundStyle(Color.theme.accentColor)
        }
    }
    
    private var applicationSection : some View {
        
        Section {
            //control-cmd-spacebar for emoji insertion
            Link("Terms of Service", destination: defaultURL)
            Link("Privacy Policy", destination: defaultURL)
            Link("Company Website", destination: defaultURL)
            Link("Learn More", destination: defaultURL)
        } header: {
            Text("Application")
                .foregroundStyle(Color.theme.accentColor)
        }
    }
}

#Preview {
    SettingsView()
}
