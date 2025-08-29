//
//  CoinLogoView.swift
//  SwiftfulCrypto
//
//  Created by Alvaro Ordonez on 8/12/25.
//

import SwiftUI

struct CoinLogoView: View {
    
    let coin: CoinModel
    
    var body: some View {
        VStack {
            CoinImageView(coin: coin)
                .frame(width: 50, height: 50)
            Text(coin.symbol.uppercased())
                .font(.headline)
                .foregroundStyle(Color.theme.accentColor)
                    .lineLimit(1)
                    //allows text to downsize to fit in
                    //one line if it exceeds one line
                    .minimumScaleFactor(0.5)
            Text(coin.name)
                .font(.caption)
                .foregroundStyle(Color.theme.secondaryTextColor)
                .lineLimit(2)
                //allows text to downsize to fit in
                //in two linew if it exceeds two lines
                .minimumScaleFactor(0.5)
                .multilineTextAlignment(.center)
                
        }
    }
}


//using old Preview structure to be able to make use of dev.homeVM
//which is a sample homeViewModel to be used just to show fake data in a preview
struct CoinLogoView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CoinLogoView(coin: dev.coin)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.light)
            
            CoinLogoView(coin: dev.coin)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}
//#Preview {
//    CoinLogoView(coin: )
//}
