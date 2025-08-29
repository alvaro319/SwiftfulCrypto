//
//  CoinImageView.swift
//  SwiftfulCrypto
//
//  Created by Alvaro Ordonez on 7/31/25.
//

import SwiftUI
import Combine

struct CoinImageView: View {
    
    @StateObject private var viewModel: CoinImageViewModel
    
    init(coin: CoinModel) {
        _viewModel = StateObject(wrappedValue: CoinImageViewModel(coin: coin))
    }
    
    var body: some View {
        ZStack {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else if viewModel.isLoading {
                ProgressView()
            } else {
                Image(systemName: "questionmark")
                    .foregroundStyle(Color.theme.secondaryTextColor)
            }
        }
    }
}

//@available(iOS 17.0, *)
//#Preview(traits: .sizeThatFitsLayout) {
//    CoinImageView(coin: dev.coin)
//        .padding()
//}

//OR:

struct CoinImageView_Previews: PreviewProvider {
    static var previews: some View {
        CoinImageView(coin: dev.coin)
            .previewLayout(.sizeThatFits)
    }
}
