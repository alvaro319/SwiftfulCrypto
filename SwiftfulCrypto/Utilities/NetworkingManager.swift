//
//  NetworkingManager.swift
//  SwiftfulCrypto
//
//  Created by Alvaro Ordonez  7/31/25.
//
import Foundation
import Combine

class NetworkingManager {
    
    enum NetworkingError: LocalizedError {
        //case badURLResponse
        case badURLResponse(url: URL)
        case unknown
        
        var errorDescription: String? {
            switch self {
            case .badURLResponse(url: let url): return "[🔥] Bad response from URL: \(url)"
            case .unknown: return "[⚠️] Unknown error occured"
            }
        }
    }
    
    //Usage: NetworkingManager.download(url: URL object)
    static func download(url: URL) -> AnyPublisher<Data, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
        //dataTaskPublisher automatically executes on background thread
        //this line is optional
        .subscribe(on: DispatchQueue.global(qos: .default))
        /*
        when the response comes back, we check the URL response by passing in
        the output that was sent back from the request, we must now check that
        output. The output will be Data and a Response.... see handleURLResponse()
         */
        .tryMap({try handleURLResponse(output: $0, url: url)})
        //response hasn't been decoded yet, it is decoded in the calling
        //service manager object, therefore, let's keep the decoding part
        //running on the background thread by removing recieving of
        //data on the main thread. When the data is resturned to the
        //calling service, it can be decoded(still on a background thread)
        //and then can run on the main thread when the calling service
        //includes: .receive(on: DispatchQueue.main)
        
        //.receive(on: DispatchQueue.main)
        /*
        this erases the Publisher type for the publisher above, namely, the
         dataTaskPublisher and converts it into any Publisher type allowing us
         to make use of a generic publisher return type:
         */
        .eraseToAnyPublisher()
    }
    //NOTE!
    //original function before making tryMap more efficient by using a function to
    //check for the response and return data when response is good
    //To create handleURLResponse(output) below, hold the option keyboard key
    //and check the type of output in the .tryMap{} a few lines below
    //The type that comes into the .tryMap{} closure is of type:
    //URLSession.DataTaskPublisher.Output
    //so we define the function header like this:
    //static func handleURLResponse(output: URLSession.DataTaskPublisher.Output)
    //because we may throw an error if the response isn't good, we add throw to the header:
    //static func handleURLResponse(output: URLSession.DataTaskPublisher.Output) throws
    //and when the response is good we are returning an object of type Data:
    //static func handleURLResponse(output: URLSession.DataTaskPublisher.Output) throws -> Data
    
    /*
    static func download(url: URL) -> AnyPublisher<Data, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
        .subscribe(on: DispatchQueue.global(qos: .default))
        .tryMap{ (output) -> Data in
            guard let response = output.response as? HTTPURLResponse, response.statusCode >= 200 && response.statusCode < 300 else {
                throw URLError(.badServerResponse)
            }
            return output.data
        }
        .receive(on: DispatchQueue.main)
        //this erases the Publisher type for the publisher above, namely, the dataTaskPublisher
        //and converts it into any Publisher type allowing us
        //to make use of a generic publisher return type:
        //
        .eraseToAnyPublisher()
    }
     */
    
    static func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
        guard
            //output.response is of type URL response, we need it to be of type HTTPURLResponse
            let response = output.response as? HTTPURLResponse, response.statusCode >= 200 && response.statusCode < 300 else {
                //include throws above in function header
                //throw URLError(NetworkingError)
            
            //custom error response
            //throw NetworkingError.badURLResponse
            throw NetworkingError.badURLResponse(url: url)
            }
        //Returns object of type Data
        return output.data
    }
    
    static func handleCompletion(completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished://success
            break;
            //if handleURLResponse throws an error, lands here.
        case .failure(let error):
            print("Error downloading data. \(error)")
        }
    }
}
