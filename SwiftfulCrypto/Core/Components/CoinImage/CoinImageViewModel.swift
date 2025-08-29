//
//  CoinImageViewModel.swift
//  SwiftfulCrypto
//
//  Created by Alvaro Ordonez on 7/31/25.
//

import Foundation
import Combine
import SwiftUI//for UIImage

class CoinImageViewModel: ObservableObject {
    
    @Published var image: UIImage? = nil
    @Published var isLoading: Bool = false
    private let imageService: CoinImageService
    var cancellables = Set<AnyCancellable>()//import Combine
    
    //create a NetworkManagerObject here
    
    private let coin: CoinModel
    init(coin: CoinModel) {
        //initialize NetworkManagerObject with coin image's url... coin.imageName
        self.coin = coin
        self.imageService = CoinImageService(coin: coin)
        self.addSubscribers()
        self.isLoading = true//loading has started
    }
    
    private func addSubscribers() {
        //subscribes(with .sink) to the dataService's allCoins array
        imageService.$image
            .sink(receiveCompletion: { [weak self](_) in
                self?.isLoading = false
            }, receiveValue: { [weak self] returnedImage in
                self?.image = returnedImage
                self?.isLoading = false
            })
//            .sink { [weak self] returnedImage in
//                self?.image = returnedImage
//            }
            .store(in: &cancellables)
    }
}
