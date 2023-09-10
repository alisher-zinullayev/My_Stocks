//
//  DefaultStocksMetaDataLocalDataSource.swift
//  MyStocks_Final
//
//  Created by Alisher Zinullayev on 07.09.2023.
//

import Foundation

protocol StocksMetadataLocalDataSource: AnyObject {
    func listStocksMetadata() -> [StockMetaData]
}

protocol StocksRemoteDataSource: AnyObject {
    func fetchStock(ticker: String) async throws -> StockPricesResponse
}

final class DefaultStocksMetadataLocalDataSource: StocksMetadataLocalDataSource, StocksRemoteDataSource {
    
    static let shared = DefaultStocksMetadataLocalDataSource()
    
    var listStocks: [StockMetaData] = []
    
    func listStocksMetadata() -> [StockMetaData] {
        if let path = Bundle.main.path(forResource: "stockProfiles", ofType: "json") {
            do {
                let url = URL(fileURLWithPath: path)
                let data = try Data(contentsOf: url, options: .mappedIfSafe)
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase // Use this if your JSON keys are in snake_case
                let json = try jsonDecoder.decode([StockMetaData].self, from: data)
                listStocks = json
                return json
            } catch {
                return []
            }
        }
        return []
    }
    
    func fetchStock(ticker: String) async throws -> StockPricesResponse {
        guard let url = URL(string: "\(Constants.baseURL)quote?symbol=\(ticker)&token=\(Constants.API_KEY)") else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        // Perform the network request asynchronously
        do {
            let (data, _) = try await URLSession.shared.data(from: request.url!)
            let decoder = JSONDecoder()
            let stockResponse = try decoder.decode(StockPricesResponse.self, from: data)
            return stockResponse
        } catch {
            throw NetworkError.networkError(error)
        }
    }
    
}

enum NetworkError: Error {
    case invalidURL
    case networkError(Error)
    case rateLimitExceeded
}

struct Constants {
    static let API_KEY = "cii2as9r01quio6uh8lgcii2as9r01quio6uh8m0"
    static let baseURL = "https://finnhub.io/api/v1/"
}

//class DefaultStocksMetadataLocalDataSource: StocksMetadataLocalDataSource{
//
//    static let shared = DefaultStocksMetadataLocalDataSource()
//
//    var listStocks: [StockMetaData] = []
//
//    func listStocksMetadata() -> [StockMetaData] {
//        if let path = Bundle.main.path(forResource: "stockProfiles", ofType: "json") {
//            do {
//                let url = URL(fileURLWithPath: path)
//                let data = try Data(contentsOf: url, options: .mappedIfSafe)
//                let json = try JSONDecoder().decode([StockMetaData].self, from: data)
//                listStocks = json
//                return json
//            } catch {
//                return []
//            }
//        }
//        return []
//    }
//}

