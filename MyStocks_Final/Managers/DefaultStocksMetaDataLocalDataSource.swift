//
//  DefaultStocksMetaDataLocalDataSource.swift
//  MyStocks_Final
//
//  Created by Alisher Zinullayev on 07.09.2023.
//

import Foundation

protocol StocksMetadataLocalDataSource: AnyObject {
    func listStocksMetadata() -> [StockMetaDataCD]
}

final class DefaultStocksMetadataLocalDataSource: StocksMetadataLocalDataSource {
    
    static let shared = DefaultStocksMetadataLocalDataSource()
    
    func listStocksMetadata() -> [StockMetaDataCD] {
        if let path = Bundle.main.path(forResource: "stockProfiles", ofType: "json") {
            do {
                let url = URL(fileURLWithPath: path)
                let data = try Data(contentsOf: url, options: .mappedIfSafe)
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                let json = try jsonDecoder.decode([StockMetaDataCD].self, from: data)
                return json
            } catch {
                return []
            }
        }
        return []
    }
}

enum NetworkError: Error {
    case invalidURL
    case networkError(Error)
    case rateLimitExceeded
}
