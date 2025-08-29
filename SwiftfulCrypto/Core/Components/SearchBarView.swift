//
//  SearchBarView.swift
//  SwiftfulCrypto
//
//  Created by Alvaro Ordonez on 8/6/25.
//

import SwiftUI

struct SearchBarView: View {
    
    //@State var searchText: String = ""
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(
                    searchText.isEmpty ? Color.theme.secondaryTextColor : Color.theme.accentColor
                )
            TextField("Search by name or symbol...", text: $searchText)
                //sets color of user written text in text field
                .foregroundStyle(Color.theme.accentColor)
                //both disables autocorrection
                .keyboardType(.asciiCapable)
                .autocorrectionDisabled(true)
                //provides an 'x' to clear out any text
                .overlay(
                    Image(systemName: "xmark.circle.fill")
                        //adding padding and an offset to increase
                        //the tappable are of the 'x' circle
                        //to make it easier on the user
                        .padding()
                        .offset(x: 10)
                        //used red background just to see the tappable area of the 'x' circle
                        //.background(Color.red)
                        .foregroundStyle(Color.theme.accentColor)
                        .opacity(searchText.isEmpty ? 0.0 : 1.0)
                        .onTapGesture {
                            //dismiss the keyboard by adding endEditing() in the
                            //UIApplication extension
                            UIApplication.shared.endEditing()
                            searchText = ""
                        }
                    ,alignment: .trailing
                )
        }
        .font(.headline)
        .padding()//pads contents within HStack above
        .background(
            //be default the color of an object within
            //a .background() will be black
            RoundedRectangle(cornerRadius: 25)
                //make the rectangle gray
                .fill(Color.theme.backgroundColor)
                .shadow(
                    color: Color.theme.accentColor.opacity(0.15),
                    radius: 10, x: 0, y: 0
                )
        )
        .padding()//pads the searchbar with the shadow
    }
}

@available(iOS 17.0, *)
#Preview(traits: .sizeThatFitsLayout) {
    Group {
        SearchBarView(searchText: .constant(""))
            .preferredColorScheme(.light)
        
        SearchBarView(searchText: .constant(""))
            //.preferredColorScheme(.light)
            //for some reason need to use .colorScheme instead
            .colorScheme(.dark)
    }
    
}
