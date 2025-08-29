//
//  XMarkButton.swift
//  SwiftfulCrypto
//
//  Created by Alvaro Ordonez on 8/12/25.
//

import SwiftUI

struct XMarkButton: View {
    
    //connects to the current presentation mode of the screen
    //the user is on(a view called up modally as a sheet)
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Button(
            action: {
                //will be deprecated
                //presentationMode.wrappedValue.dismiss()
                /* not used because we are going to make a component for
                  the xmark button so it can be reused */
                dismiss()
            }, label: {
                Image(systemName: "xmark")
                    .font(.headline)
            }
        )//end button

    }
}

#Preview {
    XMarkButton()
}
