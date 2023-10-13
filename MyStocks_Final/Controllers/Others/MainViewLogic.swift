//
//  MainViewLogic.swift
//  MyStocks_Final
//
//  Created by Alisher Zinullayev on 20.09.2023.
//

import Foundation

class MainViewLogic {
    
    private let stocksMetadataLocalDataSource: DefaultStocksMetadataLocalDataSource
    private let stocksRemoteDataSource: DefaultStockRemoteDataSource
    
    var onDataFetched: (([StockMetaData]) -> Void)? // closure to notify the view controller when data is fetched and ready for display
    var onStockDataFetched: ((String, StockPricesResponse) -> Void)?
    
    init(stocksMetadataLocalDataSource: DefaultStocksMetadataLocalDataSource, stocksRemoteDataSource: DefaultStockRemoteDataSource) {
        self.stocksMetadataLocalDataSource = stocksMetadataLocalDataSource
        self.stocksRemoteDataSource = stocksRemoteDataSource
    }
    
    func fetchStocks() {
        Task {
            do {
                let stocksList = try await stocksMetadataLocalDataSource.listStocksMetadata()
                onDataFetched?(stocksList)
                
                for stock in stocksList {
                    let stockResponse = try await stocksRemoteDataSource.fetchStock(ticker: stock.ticker)
                    onStockDataFetched?(stock.ticker, stockResponse)
                }
            } catch {
                print("Error fetching stock data: \(error)")
            }
        }
    }
}
