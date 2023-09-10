//
//  ViewController.swift
//  MyStocks_Final
//
//  Created by Alisher Zinullayev on 07.09.2023.
//

import UIKit

final class MainViewController: UIViewController {

    private var stocksList: [StockMetaData] = []
    
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
        fetchStocks()
        view.backgroundColor = .systemBrown
        
//        for i in stocksList {
//            print(i.ticker)
//            Task.init {
//                do {
//                    let stockResponse = try await DefaultStocksMetadataLocalDataSource.shared.fetchStock(ticker: i.ticker)
//                    print("Current Price: \(stockResponse.c)")
//                    print("Change Percent: \(stockResponse.dp)")
//                } catch {
//                    print("Error fetching stock data: \(error)")
//                }
//            }
//        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        stocksTableView.frame = view.bounds
    }
    
    private func fetchStocks() {
        Task {
            do {
                // Fetch the list of stock metadata
                stocksList = DefaultStocksMetadataLocalDataSource.shared.listStocksMetadata()
                print(stocksList)
                
                // Fetch stock data for each ticker
                for i in stocksList {
                    print(i.ticker)
                    let stockResponse = try await DefaultStocksMetadataLocalDataSource.shared.fetchStock(ticker: i.ticker)
                    print("Current Price: \(stockResponse.c)")
                    print("Change Percent: \(stockResponse.dp)")
                }
            } catch {
                print("Error fetching stock data: \(error)")
            }
        }
    }
    
    private func setupTableView() {
        view.addSubview(stocksTableView)
        stocksTableView.delegate = self
        stocksTableView.dataSource = self
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
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: false)
//    }
}

//        cell.configure(with: indexPath.row)
//        cell.setSelected(false, animated: true)

    

