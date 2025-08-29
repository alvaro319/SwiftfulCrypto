//
//  HomeViewModel.swift
//  SwiftfulCrypto
//
//  Created by Alvaro Ordonez on 7/30/25.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
//    @Published var statistics: [StatisticModel] = [
//        StatisticModel(title: "Title", value: "Value", percentageChange: 1),
//        StatisticModel(title: "Title", value: "Value"),
//        StatisticModel(title: "Title", value: "Value"),
//        StatisticModel(title: "Title", value: "Value", percentageChange: -7)
//    ]
    
    @Published var statistics: [StatisticModel] = []
    
    //allCoins are the filtered Coins when user filters via search bar
    //allCoins is shown on HomeView.
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    @Published var marketData: MarketDataModel? = nil
    @Published var isLoading: Bool = false
    @Published var sortOption: SortOption = .holdings
    
    //for search bar
    @Published var searchText: String = ""
    
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private let portfolioDataService = PortfolioDataService()
    var cancellables = Set<AnyCancellable>()//import Combine
    
    enum SortOption {
        case rank
        case rankReversed
        case holdings//highest amount of holdings at the top
        case holdingsReversed//highest amount of holdings at the bottom
        case price
        case priceReversed
    }
    
    init() {
        //used this to get one allCoins item and one portfolioCoins item
        /*
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.allCoins.append(DeveloperPreview.instance.coin)
            self.portfolioCoins.append(DeveloperPreview.instance.coin)
        }
         */
        addSubscribers()
    }
    
    func addSubscribers() {
        //subscribes(with .sink) to the dataService's allCoins array
        //no longer needed since the allCoins publisher was combined with the
        //searchText publisher below
        /*
        dataService.$allCoins
            .sink { [weak self] returnedCoins in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)
        */
        
        //subscribes to data published from searchText
        $searchText
            //subscribes to 2nd publisher and combines with
            //1st publisher.... searchText
            //.combineLatest(coinDataService.$allCoins)
        
            //we now want to subscribe to the sortOption, add it,
            //as a result filterCoins now has to add a third parameter
            //Originally:
                //private func filterCoins(text: String, coins: [CoinModel] ) -> [CoinModel]]
            //new func With Sort added
                //private func filterAndSortCoins(text: String, coins: [CoinModel], sortOption: SortOption ) -> [CoinModel]]
            .combineLatest(coinDataService.$allCoins, $sortOption)
            /*
                debounce will wait 0.5 seconds before running the code starting
                at .map(). So if user types 4 letters in 0.5 seconds,
                then all 4 letters would be passed into the subscriber,
                rather than passing in one letter at a time until all 4 are sent
                it is a way to slow down the processing of what the user types in
             */
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .receive(on: DispatchQueue.main)
            //filter the coins displayed from what user entered in
            //search bar
            //.map will receive a text(for searchText subscriber) and coins(for
            //dataService.all
            //.map(filterCoins)
        
            /*
             filter the coins displayed from what the user entered in search bar
             .map will receive a text(for searchText subscriber), coins(for
             array of coinModel) and now a SortOption
             
             sorting by priced, priceReversed, rank, and rankReversed
             */
            .map(filterAndSortCoins)
            .sink { [weak self ] filteredCoinsReturned in
                self?.allCoins = filteredCoinsReturned
            }
            .store(in: &cancellables)
        
        //updates portfolioCoins(CoreData)
        /*
            coinDataService.$allCoins are all the coins available
            self?.allCoins are the coins that have been filtered.
            refer to $searchText subscriber above(when coinDataService.$allCoins
            is updated with values and the searchText has a value, the searchText
            is used to then filter all the coins and the result is stored in
            self?.allCoins
         
            Therefore, if we filter on the HomeView, then click the top
            right arrow button to get to the PortfolioView, we want to only
            show the filtered coins on the PortfolioView, so let's subscribe
            off of the self?.allCoins
         
            When self?.allCoins has been set with the filtered list of Coins
            and savedEntities has at least one entity, then we can map
            the savedEntities(which are coins with a coinID and amount) to
            the portfolioCoins
         
            Note, that allCoins gets it's value from filteredCoinsReturned, which
            if you look at the .map{} above, the coins come filtered and sorted.
            We need to filter and sort the portfolio Coins too, but can't
            add sortOption publisher here because if we do then whenever
            sortOption is modified, it will run the subscriber above and the
            subscriber below and we don't want it to .map{} twice. So
            we sort in the .sink below
            
         */
        $allCoins
            .combineLatest(portfolioDataService.$savedEntities)
            .receive(on: DispatchQueue.main)
            //defined mapAllCoinsToPortfolioCoins further below but this
            //is how you would clean up the code(left it as is but this
            //is how you would clean it up)
            //.map(mapAllCoinsToPortfolioCoins)
            .map { coinModels, portfolioEntities -> [CoinModel] in
                //we only need to find the coins that exist in the portfolioEntities
                
                /*
                  loop through the coinModels, determine if a coin is found in the
                  portfolioEntities a match will return true and subsequently
                  return the coin found in an entity
                 */
                coinModels
                    //the return type is CoinModel? because a nil can be returned if no match found
                    .compactMap { coin -> CoinModel? in
                        
                        //if entity is found that matches the current coin, grab
                        //the entity's updated amount to update the coin's
                        //holdings and return that found coin to update
                        //the portfolio coins
                        guard let entity = portfolioEntities.first(where: { $0.coinID == coin.id}) else {
                            return nil
                        }
                        //confirmed the updateHoldings is updated
                        let updatedCoin = coin.updateHoldings(amount: entity.amount)
                        return updatedCoin
                        /*
                         when portfolioDataService was initialized, it was loaded with the
                         saved entities in CoreData
                         Here while looping through each coin, we check if it exists in the
                         portfolioEntities(by comparing ids). If they match need to update
                         the entity.amount field onto the coin.updateHoldings field
                        guard let entity = portfolioEntities.first(where: { (savedEntity) -> Bool in
                            return savedEntity.coinID == coin.id
                        }) else {
                            //the return type of .compactMap is CoinModel? so we can return a nil
                            //when no match found
                            return nil
                        }
                        //coin found saved in an entity, since we are loading the entities
                          from CoreData(by comparing IDs), then get the entity's amount
                          and update the
                        //coin's updateHoldings
                        return coin.updateHoldings(amount: entity.amount)
                        */
                    } //end compactMap
            }//end map
            .sink { [weak self] returnedCoinsFoundInEntity in
                guard let self = self else { return }
                //confirmed the returnedCoinsFoundInEntity contains the coin
                //with the updated updateHoldings field
                //now sort the portfolioCoins by holdings and reverseHoldings.
                //Recall that allCoins doesn't have a portfolio of coins,
                //portfolio of Coins only shows when you hit the chevron in
                //upper right hand corner of the HomeView. So we only sort
                //based on holdings or reversedHoldings for portfolioCoins
                //over here
                self.portfolioCoins = self.sortPortfolioCoinsIfNeeded(coins: returnedCoinsFoundInEntity)
            }
            .store(in: &cancellables)
        
        //want to convert the returned marketDataModel data to the Published
        //statistics array of type StatisticModel(the one we initially created
        //with fake data, above)
        marketDataService.$marketData
            .combineLatest($portfolioCoins)
            .receive(on: DispatchQueue.main)
            .map(mapGlobalMarketData)
            //subscribes to marketData and portfolioCoins
            .sink { [weak self] returnedStats in
                self?.statistics = returnedStats
                //this is when ALL the data finishes loading
                self?.isLoading = false
            }
            .store(in: &cancellables)
    }
        
    func updatePorfolio(coin: CoinModel, amount: Double) {
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
    
    func reloadData() {
        isLoading = true
        //need to call CoinDataService's getCoin() function so need to change
        //access modifier for getCoin() from private to public
        coinDataService.getCoins()
        marketDataService.getMarketData()
        //make phone vibrate
        HapticsManager.notification(type: .success)
    }
    
    func filterAndSortCoins(text: String, coins: [CoinModel], sort: SortOption) -> [CoinModel] {
        //var filteredCoins = filterCoins(text: text, coins: coins)
        
        //this sortCoins() returns a newly created sorted Coins
        //let sortedCoins = sortCoins(sort: sortOption, coins: filteredCoins)
        
        //return sortedCoins
        
        //filter first, then sort
        var updatedCoins = filterCoins(text: text, coins: coins)
        //this sortCoins() returns the same updatedCoins but sorted
        sortCoins(sort: sortOption, coins: &updatedCoins)
        return updatedCoins
    }
    
    //receives text for the searchText and [CoinModel] for the coins
    private func filterCoins(text: String, coins: [CoinModel]) -> [CoinModel] {
        if text.isEmpty {
            //no filtering performed in search bar, return all coins
            return coins
        } else {
            let lowercasedText = text.lowercased()
            
            //filter out the coins based on search bar text
            let filteredCoins = coins.filter({ coin -> Bool in
                return coin.name.lowercased().contains(lowercasedText) ||
                coin.symbol.lowercased().contains(lowercasedText) ||
                coin.id.lowercased().contains(lowercasedText)
                
            })
            
            return filteredCoins
        }
    }
    
    //this function sorts the incoming [CoinModel] and returns
    //a newly created sorted [CoinModel]
    /*
    private func sortCoins(sort: SortOption, coins: [CoinModel]) -> [CoinModel] {
        
        switch sort {
        case .rank, .holdings:
            //loops throught all coins comparing two at at a time
            return coins.sorted { coin1, coin2 in
                return coin1.rank < coin2.rank
            }
            //shorthand way:
            //return coins.sorted(by: { $0.rank < $1.rank })
        case .rankReversed, .holdingsReversed:
            //loops throught all coins comparing two at at a time
            return coins.sorted { coin1, coin2 in
                return coin1.rank > coin2.rank
            }
            //shorthand way:
            //return coins.sorted(by: { $0.rank > $1.rank })
        case .price:
            return coins.sorted(by: { $0.currentPrice > $1.currentPrice })
        case .priceReversed:
            return coins.sorted(by: { $0.currentPrice < $1.currentPrice })
        }
    }
     */
    
    //this function sorts the incoming [CoinModel] and returns
    //the same [CoinModel] but sorted(more efficient to return the incoming
    //[CoinModel])
    private func sortCoins(sort: SortOption, coins: inout [CoinModel]) {
        
        switch sort {
        case .rank, .holdings:
            //loops through all coins comparing two at at a time
            //sorting is done in place, sorted, used above doesn't
            coins.sort { coin1, coin2 in
                return coin1.rank < coin2.rank
            }
            //shorthand way:
            //return coins.sort(by: { $0.rank < $1.rank })
        case .rankReversed, .holdingsReversed:
            //loops throught all coins comparing two at at a time
            coins.sort { coin1, coin2 in
                return coin1.rank > coin2.rank
            }
            //shorthand way:
            //return coins.sort(by: { $0.rank > $1.rank })
        case .price:
            coins.sort(by: { $0.currentPrice > $1.currentPrice })
        case .priceReversed:
            coins.sort(by: { $0.currentPrice < $1.currentPrice })
        }
    }
    
    //already sorted by everything but holdings and reverseHoldings
    private func sortPortfolioCoinsIfNeeded(coins: [CoinModel]) -> [CoinModel] {
        //will only sort by holdings or reverseHoldings if needed
        switch sortOption {
        case .holdings:
            return coins.sorted { $0.currentHoldingsValue > $1.currentHoldingsValue }
        case .holdingsReversed:
            return coins.sorted { $0.currentHoldingsValue < $1.currentHoldingsValue }
        default:
            return coins
        }
    }
    
    private func mapAllCoinsToPortfolioCoins(coinModels: [CoinModel], portfolioEntities: [PortfolioEntity]) -> [CoinModel] {
        /*
          loop through the coinModels, determine if a coin is found in the
          portfolioEntities a match will return true and subsequently
          return the coin found in an entity
         */
        coinModels
            //the return type is CoinModel? because a nil can be returned if no match found
            .compactMap { coin -> CoinModel? in
                
                guard let entity = portfolioEntities.first(where: { $0.coinID == coin.id}) else {
                    return nil
                }
                //confirmed the updateHoldings is updated
                let updatedCoin = coin.updateHoldings(amount: entity.amount)
                return updatedCoin
                /*
                 when portfolioDataService was initialized, it was loaded with the
                 saved entities in CoreData
                 Here while looping through each coin, we check if it exists in the
                 portfolioEntities(by comparing ids). If they match need to update
                 the entity.amount field onto the coin.updateHoldings field
                guard let entity = portfolioEntities.first(where: { (savedEntity) -> Bool in
                    return savedEntity.coinID == coin.id
                }) else {
                    //the return type of .compactMap is CoinModel? so we can return a nil
                    //when no match found
                    return nil
                }
                //coin found saved in an entity, since we are loading the entities
                  from CoreData(by comparing IDs), then get the entity's amount
                  and update the
                //coin's updateHoldings
                return coin.updateHoldings(amount: entity.amount)
                */
            } //end compactMap
    }
    
    private func mapGlobalMarketData(marketDataModel: MarketDataModel?, portfolioCoins: [CoinModel]) -> [StatisticModel] {
        var stats: [StatisticModel] = []
        //marketDataModel can be nil so let's check
        guard let data = marketDataModel
        else {
            //return the empty array
            return stats
        }
        
        let marketCap = StatisticModel(
                    title: "Market Cap",
                    value: data.marketCap,
                    percentageChange: data.marketCapChangePercentage24HUsd)
        //stats.append(marketCap)
        
        let volume = StatisticModel(
                        title: "24h Volume",
                        value: data.volume)
        //stats.append(volume)
        
        let btcDominance = StatisticModel(
                                title: "BTC Dominance",
                                value: data.btcDominance)
        
        //loops through all the coins in portfolioCoins, adds them together and returns a total value
        let portfolioValue =
            portfolioCoins
            .map { (coin) -> Double in
                return coin.currentHoldingsValue
            }//.map returns an array of doubles, but need to add all of them together
            //initial result is the starting value... 0
            .reduce(0, +)//start from zero and add all the currentHoldingsValue
        
        //shorthand version of above line
        /*
        let portfolioValue2 =
            portfolioCoins
            .map({$0.currentHoldingsValue})
            .reduce(0, +)
         */
        
        //even shorter shorthand
        //let portfolioValue = portfolioCoins.map(\.currentHoldingsValue)
        
        let previousValue =
            portfolioCoins
                .map { (coin) -> Double in
                    let currentValue = coin.currentHoldingsValue
                    //25% -> 25 -> 0.25
                    let percentChange = coin.priceChangePercentage24H ?? 0 / 100
                    let previousValue = currentValue / (1 + percentChange)
                    return previousValue
                }
                .reduce(0, +)//returns sum of all previousValue of the coins looped
        
        let percentageChange = ((portfolioValue - previousValue) / previousValue) //* 100
        
        let portfolio = StatisticModel(
            title: "Portfolio Value",
            value: portfolioValue.asCurrencyWith2Decimal(),
            percentageChange: percentageChange)
        
        stats.append(contentsOf: [
            marketCap,
            volume,
            btcDominance,
            portfolio
        ])
        
        return stats

    }
    
}
