//
//  CoinDataService.swift
//  SwiftfulCrypto
//
//  Created by Alvaro Ordonez on 7/30/25.
//

import Foundation
import Combine

//https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h

class CoinDataService: ObservableObject {
    
    //allCoins is a publisher
    @Published var allCoins: [CoinModel] = []
    var coinSubscription: AnyCancellable?
    var cancellables = Set<AnyCancellable>()//import Combine
    
    //static var shared = CoinDataService()
    init(){
        getCoins()
    }
    
    //HomeViewModel's refreshData() needs to call this function,
    //access modifier needs to change from private to public
    public func getCoins() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h") else {
            return
        }
        
        //when calling dataTaskPublisher(within NetworkingManager.download), it
        //assumes this url could be sending data over time
        //it assumes it might publish values now and it stays listening
        //in case we have more published values in the feature, but we know this
        //url is just a single get request, so if we receive good data then
        //cancel the CoinSubscription
        coinSubscription =
            NetworkingManager.download(url: url)
                //decodes in background thread because we commented out
                // the line: .receive(on: DispatchQueue.main) from
                //within NetworkingManager's download function; had we left
                //that line in, then decoding would occur in main thread and
                //typically it is best to decode in background thread
                .decode(type:[CoinModel].self, decoder: JSONDecoder())
                //always receive on a main thread after decoding
                .receive(on: DispatchQueue.main)
                .sink(
                    receiveCompletion: NetworkingManager.handleCompletion,
                    receiveValue: { [weak self] (returnedCoinModels) in
                        self?.allCoins = returnedCoinModels
                        //since we know the url request above only returns data once per request,
                        //we can cancel the subscriber once we have received good data once.
                        self?.coinSubscription?.cancel()
                })
                //if we store this call to dataTaskPublisher into this set of cancellables,
                //it will be difficult to know which item in this set pertains to this
                //dataTaskPublisher if we wanted to cancel it
                //.store(in: &cancellables)
        
        //moved to Networking Manager for Networking Layer reuse
        /*
        coinSubscription =
        URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .receive(on: DispatchQueue.main)
            .tryMap(handleOutput)
            .decode(type:[CoinModel].self, decoder: JSONDecoder())
            .sink{ completion in
                  switch completion {
                    case .finished://success
                        break;
                    //if handleOutput throws an error, lands here.
                    case .failure(let error):
                        print("Error downloading data. \(error)")
                  }

            } receiveValue: { [weak self]returnedCoinModels in
                self?.allCoins = returnedCoinModels
                //since we know the url request above only returns data once per request,
                //we can cancel the subscriber once we have received good data once.
                self?.coinSubscription?.cancel()
            }
            //if we store this call to dataTaskPublisher into this set of cancellables,
            //it will be difficult to know which item in this set pertains to this
            //dataTaskPublisher if we wanted to cancel it
            //.store(in: &cancellables)
         */
    }
    
    //moved to Networking Manager for Networking Layer reuse - renamed to handleURLOutput
    /*
    //this func is private because it only needs to be used within this class
    private func handleOutput(output: URLSession.DataTaskPublisher.Output) throws -> Data {
        
        guard
            //output.response is of type URL response, we need it to be of type HTTPURLResponse
            let response = output.response as? HTTPURLResponse, response.statusCode >= 200 && response.statusCode < 300 else {
                throw URLError(.badServerResponse)
            }
        return output.data
    }
     */
    
}
