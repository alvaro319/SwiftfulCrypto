//
//  CoinImageService.swift
//  SwiftfulCrypto
//
//  Created by Alvaro Ordonez on 7/31/25.
//

import Foundation
import SwiftUI
import Combine

class CoinImageService {
    
    @Published var image: UIImage? = nil
    private var imageSubscription: AnyCancellable?
    private let coin: CoinModel
    private let fileManager = LocalFileManager.instance
    private let folderName = "coin_images"
    private let imageName: String
    
    init(coin: CoinModel) {
        self.coin = coin
        self.imageName = coin.id
        getCoinImage()
    }
    
    //first try to get the coin image from the file manager, if it fails,
    //then download it
    private func getCoinImage() {
        //here we can hard code a folder path because this file is only for saving images to the file manager
        if let savedImageInFileManager = fileManager.getImage(imageName: imageName, folderName: folderName) {
            image = savedImageInFileManager
            //print("Retrieved image from file manager")
        }
        else {
            downloadCoinImage()
            //print("Downloading Image now!")
        }
    }
    
    private func downloadCoinImage() {
        
        guard let url = URL(string: coin.image) else {
            return
        }
        
        imageSubscription =
            NetworkingManager.download(url: url)
                //data is of type Data, so when NetworkingManager.download() returns,
                //we can use that Data object, namely data to convert it into a UIImage
                .tryMap({ (data) -> UIImage? in
                    return UIImage(data: data)
                })
                //always receive on a main thread after decoding
                .receive(on: DispatchQueue.main)
                //If we try to use the line below we get this compiler error:
                //Instance method 'decode(type:decoder:)' requires that 'UIImage' conform to 'Decodable'
                //no need to use a JSONDecoder() because the tryMap above can
                //easily map the data object of type Data to a UIImage
                //.decode(type:UIImage.self, decoder: JSONDecoder())
                .sink(
                    receiveCompletion: NetworkingManager.handleCompletion,
                    receiveValue: { [weak self] (returnedImage) in
                        //let's make sure we have this reference to self first
                        guard let self = self
                        else {
                            return
                        }
                        
                        //using a guard let above allows us to not have to use the
                        //optional symbol '?' after self:
                        //self?.image = returnedImage
                        if let downloadedImage = returnedImage {
                            self.image = downloadedImage
                            //since we know the url request above only returns data once per request, we can cancel the subscriber once we have received good data once.
                            self.imageSubscription?.cancel()
                            self.fileManager.saveImage(image: downloadedImage, imageName: self.imageName, folderName: self.folderName)
                        }
                })

    }//end downloadImage
}
