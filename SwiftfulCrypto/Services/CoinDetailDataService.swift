//
//  CoinDetailDataService.swift
//  SwiftfulCrypto
//
//  Created by Alvaro Ordonez on 8/19/25.
//

import Foundation
import Combine

class CoinDetailDataService {
    
    @Published var coinDetails: CoinDetailModel? = nil
    
    var coinDetailSubscription : AnyCancellable?
    
    let coin: CoinModel
    
    init(coin: CoinModel) {
        self.coin = coin
        self.getCoinDetails()
    }
    
    private func getCoinDetails() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(coin.id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false&dex_pair_format=symbol")
        else {
            return
        }
        
        coinDetailSubscription = NetworkingManager.download(url: url)
            //decodes in background thread because we commented out
            // the line: .receive(on: DispatchQueue.main) from
            //within NetworkingManager's download function; had we left
            //that line in, then decoding would occur in main thread and
            //typically it is best to decode in background thread
            .decode(type: CoinDetailModel.self, decoder: JSONDecoder())
            //always receive on a main thread after decoding
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion,
                  receiveValue: { [weak self] returnedCoinDetails in
                        self?.coinDetails = returnedCoinDetails
                        self?.coinDetailSubscription?.cancel()
            })
    }
}
