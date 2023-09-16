//
//  ViewController.swift
//  MyStocks_Final
//
//  Created by Alisher Zinullayev on 07.09.2023.
//

import UIKit

final class MainViewController: UIViewController {
    
    private var stocksList: [StockMetaData] = []
    private var logic: MainViewLogic!
    
    private let stocksTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        view.backgroundColor = .systemBrown

        logic = MainViewLogic(
            stocksMetadataLocalDataSource: DefaultStocksMetadataLocalDataSource(),
            stocksRemoteDataSource: DefaultStockRemoteDataSource()
        )
        
        logic.onDataFetched = { [weak self] stocksList in
            DispatchQueue.main.async {
                self?.stocksList = stocksList
                self?.stocksTableView.reloadData()
            }
        }
        logic.fetchStocks()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        stocksTableView.frame = view.bounds
    }
    
    private func setupTableView() {
        view.addSubview(stocksTableView)
        stocksTableView.delegate = self
        stocksTableView.dataSource = self
        stocksTableView.separatorStyle = .none
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 14
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.identifier, for: indexPath) as? MainTableViewCell else {return UITableViewCell()}
        cell.configure(with: indexPath.row)
        return cell
    }
}

class MainViewLogic {
    
    private let stocksMetadataLocalDataSource: DefaultStocksMetadataLocalDataSource
    private let stocksRemoteDataSource: DefaultStockRemoteDataSource
    
    var onDataFetched: (([StockMetaData]) -> Void)? // closure to notify the view controller when data is fetched and ready for display

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
                    print(stock.ticker)
                    print("Current Price: \(stockResponse.c ?? 123)")
                    print("Change Percent: \(stockResponse.dp ?? 123)")
                }
            } catch {
                print("Error fetching stock data: \(error)")
            }
        }
    }
}
