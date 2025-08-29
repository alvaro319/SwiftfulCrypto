//
//  CoinRowView.swift
//  SwiftfulCrypto
//
//  Created by Alvaro Ordonez on 7/30/25.
//

import SwiftUI

struct CoinRowView: View {
    
    //every time we create a CoinRowView,
    //must pass in a CoinModel object
    let coin: CoinModel
    let showHoldingsColumn: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            //column for crypto coin
            leftColumn
            Spacer()
            if showHoldingsColumn {
                centerColumn
            }
            rightColumn
        }
        .font(.subheadline)
        //makes whole row clickable
        .contentShape(Rectangle())
        //same as contentShape above
//        .background(
//            Color.theme.backgroundColor.opacity(0.001)
//        )
    }
}

extension CoinRowView {
    private var leftColumn: some View {
        //placed in HStack because the three items below were in an
        //HStack
        HStack(spacing: 0) {
            Text("\(coin.rank)")
                .font(.caption)
                .foregroundStyle(Color.theme.secondaryTextColor)
                .frame(minWidth: 30)
            //Circle()
            CoinImageView(coin: coin)
                .frame(width: 30, height: 30)
            Text(coin.symbol.uppercased())
                .font(.headline)
                .padding(.leading, 6)
                .foregroundStyle(Color.theme.accentColor)
        }
    }
    
    private var centerColumn: some View {
        VStack(alignment: .trailing) {
            Text(coin.currentHoldingsValue.asCurrencyWith2Decimal())
                .bold()
            Text((coin.currentHoldings ?? 0).asNumberString())
        }
        .foregroundStyle(Color.theme.accentColor)
    }
    
    private var rightColumn: some View {
        VStack(alignment: .trailing) {
            //asCurrencyWithDecimal() defined in Double Extension folder
            Text("\(coin.currentPrice.asCurrencyWith6Decimal())")
                .bold()
                .foregroundStyle(Color.theme.accentColor)
            Text(coin.priceChangePercentage24H?.asPercentString() ?? "")
                .foregroundStyle(
                    ((coin.priceChangePercentage24H ?? 0) >= 0) ?
                    Color.theme.greenColor :
                    Color.theme.redColor
                )
        }
        //makes this VStack column 1/3 of the screen
        //UIScreen.main.bounds should only be used for apps in portrait mode
        //if not in portrait only mode then use Geometry Reader
        .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
        
    }
}

//replaced the default #Preview below with this older preview sytax
//to be able to follow the crypto tutorial
struct CoinRowView_Previews: PreviewProvider {
    static var previews: some View {
        //created an extension of PreviewProvider in PreviewProvider.swift
        //In the PreviewProvider extension the static var called dev,
        //which returns an instance of the CoinModel class, which
        //contains an initialized CoinModel class called coin
        Group {
            //Remember to select the Selectable button in the Canvas to be able to view both views(they're displayed side by side
            CoinRowView(coin: dev.coin, showHoldingsColumn: true)
                .previewLayout(.sizeThatFits)
            CoinRowView(coin: dev.coin, showHoldingsColumn: true)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
        
    }
}

//#Preview {
//    CoinRowView()
//}
