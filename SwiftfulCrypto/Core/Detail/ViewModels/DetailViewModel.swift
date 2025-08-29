//
//  DetailViewModel.swift
//  SwiftfulCrypto
//
//  Created by Alvaro Ordonez on 8/19/25.
//

import Foundation
import Combine

class DetailViewModel: ObservableObject {
    
    //let coin: CoinModel
    @Published var coin: CoinModel
    @Published var coinDetails: CoinDetailModel? = nil
    
    @Published var overviewStatisticModel: [StatisticModel] = []
    @Published var additionalDetailsStatisticModel: [StatisticModel] = []
    
    @Published var coinDescription: String? = nil
    @Published var websiteURL: String? = nil
    @Published var redditURL: String? = nil
    
    private let coinDetailService: CoinDetailDataService
    var cancellables = Set<AnyCancellable>()//import Combine
    
    init(coin: CoinModel) {
        self.coin = coin
        self.coinDetailService = CoinDetailDataService(coin: coin)
        self.addSubscribers()
    }
    
    private func addSubscribers() {
        
        //used when initially creating DetailView just to have data displayed in
        //DetailView
        /*
        coinDetailService.$coinDetails
            .sink { [weak self] returnedCoinDetail in
                if let coinDetails = returnedCoinDetail {
                    self?.coinDetails = coinDetails
                }
            }
            .store(in: &cancellables)
         */
        
        coinDetailService.$coinDetails
            //going to need a coin, define coin as a Publisher and subscribe here
            //when coin is passed in and assigned to self.coin, it will publish the data
            .combineLatest($coin)
            .receive(on: DispatchQueue.main)
            .map(mapDataToStatistics)
            /*
                .map({ coinDetailModel, coinModel -> (overview: [StatisticModel], additional: [StatisticModel]) in
                    
                    //overview
                    let price = coinModel.currentPrice.asCurrencyWith6Decimal()
                    let pricePercentChange = coinModel.priceChangePercentage24H
                    let priceStat = StatisticModel(title: "Current Price", value: price, percentageChange: pricePercentChange)
                    
                    let marketCap = "$" + (coinModel.marketCap?.formattedWithAbbreviations() ?? "")
                    let marketCapChange = coinModel.marketCapChangePercentage24H
                    let marketCapState = StatisticModel(title: "Market Cap", value: marketCap, percentageChange: marketCapChange)
                    
                    let rank = "\(coinModel.rank)"
                    let rankStat = StatisticModel(title: rank, value: rank)
                    
                    let volume = "$" + (coinModel.totalVolume?.formattedWithAbbreviations() ?? "")
                    let volumeStat = StatisticModel(title: "Volume", value: volume)
                    
                    let overviewArray: [StatisticModel] = [
                        priceStat,
                        marketCapState,
                        rankStat,
                        volumeStat
                    ]
                    
                    //additional
                    let high = coinModel.high24H?.asCurrencyWith6Decimal() ?? "n/a"
                    let highStat = StatisticModel(title: "24h High", value: high)
                    
                    let low = coinModel.low24H?.asCurrencyWith6Decimal() ?? "n/a"
                    let lowStat = StatisticModel(title: "24h Low", value: low)
                    
                    let priceChange = coinModel.priceChange24H?.asCurrencyWith6Decimal() ?? "n/a"
                    let pricePercentChange2 = coinModel.priceChangePercentage24H
                    let priceChangeStat = StatisticModel(title: "24h Price Change", value: priceChange, percentageChange: pricePercentChange2)
                    
                    let marketCapChange2 = "$" + (coinModel.marketCapChange24H?.formattedWithAbbreviations() ?? "")
                    let marketCapPercentChange = coinModel.marketCapChangePercentage24H
                    let marketCapChangeStat = StatisticModel(title: "24h Market Cap Change", value: marketCapChange2, percentageChange: marketCapPercentChange)
                    
                    let blockTime = coinDetailModel?.blockTimeInMinutes ?? 0
                    let blockTimeString = blockTime == 0 ? "n/a" : "\(blockTime)"
                    let blockStat = StatisticModel(title: "Block Time", value: blockTimeString)
                    
                    let hashing = coinDetailModel?.hashingAlgorithm ?? "n/a"
                    let hashingStat = StatisticModel(title: "Hashing Algorithm", value: hashing)
                    
                    let additionalArray: [StatisticModel] = [
                        highStat, lowStat, priceChangeStat, marketCapChangeStat, blockStat, hashingStat
                    ]
                    
                    return (overviewArray, additionalArray)
                })
            */
            .sink { [weak self] returnedArrays in
                self?.overviewStatisticModel = returnedArrays.overview
                self?.additionalDetailsStatisticModel = returnedArrays.additional
            }
            .store(in: &cancellables)
        
        /*
         Here we subsribe a second time to coinDetails to get the coinDescription,
         the websiteURL, and the redditURL.
         This approach is cleaner instead of changing mapDataToStatistics function to
         also map the description, websiteURL, and redditURL to the three published
         variables: coinDescription, websiteURL, and redditURL
         */
        coinDetailService.$coinDetails
            .receive(on: DispatchQueue.main)
            .sink { [weak self] returnedCoinDetails in
                //self?.coinDescription = returnedCoinDetails?.description?.en
                self?.coinDescription = returnedCoinDetails?.readableDescription
                self?.websiteURL = returnedCoinDetails?.links?.homepage?.first
                self?.redditURL = returnedCoinDetails?.links?.subredditURL
            }
            .store(in: &cancellables)
    }
    
    //within CoinDataService, coinDetailModel is defined as an opional: CoinDetailModel?
    //therefore, coinDetailModel should also be an optional
    private func mapDataToStatistics(coinDetailModel: CoinDetailModel?, coinModel: CoinModel) -> (overview: [StatisticModel], additional: [StatisticModel]) {
/*
        //overview
        let price = coinModel.currentPrice.asCurrencyWith6Decimal()
        let pricePercentChange = coinModel.priceChangePercentage24H
        let priceStat = StatisticModel(title: "Current Price", value: price, percentageChange: pricePercentChange)
        
        let marketCap = "$" + (coinModel.marketCap?.formattedWithAbbreviations() ?? "")
        let marketCapChange = coinModel.marketCapChangePercentage24H
        let marketCapState = StatisticModel(title: "Market Cap", value: marketCap, percentageChange: marketCapChange)
        
        let rank = "\(coinModel.rank)"
        let rankStat = StatisticModel(title: rank, value: rank)
        
        let volume = "$" + (coinModel.totalVolume?.formattedWithAbbreviations() ?? "")
        let volumeStat = StatisticModel(title: "Volume", value: volume)
        
        let overviewArray: [StatisticModel] = [
            priceStat,
            marketCapState,
            rankStat,
            volumeStat
        ]
        
        //additional
        let high = coinModel.high24H?.asCurrencyWith6Decimal() ?? "n/a"
        let highStat = StatisticModel(title: "24h High", value: high)
        
        let low = coinModel.low24H?.asCurrencyWith6Decimal() ?? "n/a"
        let lowStat = StatisticModel(title: "24h Low", value: low)
        
        let priceChange = coinModel.priceChange24H?.asCurrencyWith6Decimal() ?? "n/a"
        let pricePercentChange2 = coinModel.priceChangePercentage24H
        let priceChangeStat = StatisticModel(title: "24h Price Change", value: priceChange, percentageChange: pricePercentChange2)
        
        let marketCapChange2 = "$" + (coinModel.marketCapChange24H?.formattedWithAbbreviations() ?? "")
        let marketCapPercentChange = coinModel.marketCapChangePercentage24H
        let marketCapChangeStat = StatisticModel(title: "24h Market Cap Change", value: marketCapChange2, percentageChange: marketCapPercentChange)
        
        let blockTime = coinDetailModel?.blockTimeInMinutes ?? 0
        let blockTimeString = blockTime == 0 ? "n/a" : "\(blockTime)"
        let blockStat = StatisticModel(title: "Block Time", value: blockTimeString)
        
        let hashing = coinDetailModel?.hashingAlgorithm ?? "n/a"
        let hashingStat = StatisticModel(title: "Hashing Algorithm", value: hashing)
        
        let additionalArray: [StatisticModel] = [
            highStat, lowStat, priceChangeStat, marketCapChangeStat, blockStat, hashingStat
        ]
        
        return (overviewArray, additionalArray)
  */
        let overviewArray = createOverViewArray(coinModel: coinModel)
        let additionalArray = createAdditionalDetailsArray(coinDetailModel: coinDetailModel, coinModel: coinModel)
        
        return(overviewArray, additionalArray)

    }
    
    private func createOverViewArray(coinModel: CoinModel) -> [StatisticModel] {
        let price = coinModel.currentPrice.asCurrencyWith6Decimal()
        let pricePercentChange = coinModel.priceChangePercentage24H
        let priceStat = StatisticModel(title: "Current Price", value: price, percentageChange: pricePercentChange)
        
        let marketCap = "$" + (coinModel.marketCap?.formattedWithAbbreviations() ?? "")
        let marketCapChange = coinModel.marketCapChangePercentage24H
        let marketCapState = StatisticModel(title: "Market Cap", value: marketCap, percentageChange: marketCapChange)
        
        let rank = "\(coinModel.rank)"
        let rankStat = StatisticModel(title: rank, value: rank)
        
        let volume = "$" + (coinModel.totalVolume?.formattedWithAbbreviations() ?? "")
        let volumeStat = StatisticModel(title: "Volume", value: volume)
        
        let overviewArray: [StatisticModel] = [
            priceStat,
            marketCapState,
            rankStat,
            volumeStat
        ]
        
        return overviewArray
    }
    
    private func createAdditionalDetailsArray(coinDetailModel: CoinDetailModel?, coinModel: CoinModel) -> [StatisticModel] {
        
        //additional details
        let high = coinModel.high24H?.asCurrencyWith6Decimal() ?? "n/a"
        let highStat = StatisticModel(title: "24h High", value: high)
        
        let low = coinModel.low24H?.asCurrencyWith6Decimal() ?? "n/a"
        let lowStat = StatisticModel(title: "24h Low", value: low)
        
        let priceChange = coinModel.priceChange24H?.asCurrencyWith6Decimal() ?? "n/a"
        let pricePercentChange = coinModel.priceChangePercentage24H
        let priceChangeStat = StatisticModel(title: "24h Price Change", value: priceChange, percentageChange: pricePercentChange)
        
        let marketCapChange = "$" + (coinModel.marketCapChange24H?.formattedWithAbbreviations() ?? "")
        let marketCapPercentChange = coinModel.marketCapChangePercentage24H
        let marketCapChangeStat = StatisticModel(title: "24h Market Cap Change", value: marketCapChange, percentageChange: marketCapPercentChange)
        
        let blockTime = coinDetailModel?.blockTimeInMinutes ?? 0
        let blockTimeString = blockTime == 0 ? "n/a" : "\(blockTime)"
        let blockStat = StatisticModel(title: "Block Time", value: blockTimeString)
        
        let hashing = coinDetailModel?.hashingAlgorithm ?? "n/a"
        let hashingStat = StatisticModel(title: "Hashing Algorithm", value: hashing)
        
        let additionalArray: [StatisticModel] = [
            highStat, lowStat, priceChangeStat, marketCapChangeStat, blockStat, hashingStat
        ]
        
        return additionalArray
    }
}
