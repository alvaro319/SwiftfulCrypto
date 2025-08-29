//
//  MarketDataService.swift
//  SwiftfulCrypto
//
//  Created by Alvaro Ordonez on 8/11/25.
//

import Foundation
import Combine

class MarketDataService: ObservableObject {
    
    //allCoins is a publisher
    @Published var marketData: MarketDataModel? = nil
    var marketDataSubscription: AnyCancellable?
    var cancellables = Set<AnyCancellable>()//import Combine
    
    init(){
        getMarketData()
    }
    
    //"https://api.coingecko.com/api/v3/global"
    //HomeViewModel's refreshData() needs to call this function,
    //access modifier needs to change from private to public
    public func getMarketData() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global")
        else {
            return
        }
        
        /*
         when calling dataTaskPublisher(within
         NetworkingManager.download), it assumes this url could be sending data over time it assumes it might publish values now and it stays listening in case we have more published values in the feature, but we know this url is just a single get request, so if we receive good data then cancel the CoinSubscription
         */
        marketDataSubscription =
            NetworkingManager.download(url: url)
            //decodes in background thread because we commented out
            // the line: .receive(on: DispatchQueue.main) from
            //within NetworkingManager's download function; had we left
            //that line in, then decoding would occur in main thread and
            //typically it is best to decode in background thread
            .decode(type:GlobalData.self, decoder: JSONDecoder())
            //always receive on a main thread after decoding
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: NetworkingManager.handleCompletion,
                receiveValue: { [weak self] (returnedGlobalData) in
                    self?.marketData = returnedGlobalData.data
                    //since we know the url request above only returns data once per request,
                    //we can cancel the subscriber once we have received good data once.
                    self?.marketDataSubscription?.cancel()
            })
            /*
             if we store this call to dataTaskPublisher into this set of cancellables, it will be difficult to know which item in this set pertains to this dataTaskPublisher if we wanted to cancel it
             */
            //.store(in: &cancellables)
    }
    
}
