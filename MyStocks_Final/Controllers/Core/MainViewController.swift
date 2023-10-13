//
//  ViewController.swift
//  MyStocks_Final
//
//  Created by Alisher Zinullayev on 07.09.2023.
//

import UIKit

let stockPricesManager = StockPricesManager()

final class MainViewController: UIViewController {
    
    private var stocksList: [StockMetaData] = [] // variable for saving name, logo, ticker
    private var stockPrices: [String : StockPricesResponse] = [ : ] // variable for saving stock prices by ticker
    let defaultStockImageLoad = DefaultStockImageLoad()
    private var logic: MainViewLogic! // declaring MainViewLogic instance
    
    private let stocksTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.identifier)
        return tableView
    }()
    
    private let stocksButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Stocks", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    private let favoriteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Favorite", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
//    override func viewWillAppear(_ animated: Bool) {
//        logicFunctions()
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        logicFunctions()
        setupButtons()
        setupTableView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    
    private func logicFunctions() {
        
        logic = MainViewLogic(  // creating an instance of the MainViewLogic class
            stocksMetadataLocalDataSource: DefaultStocksMetadataLocalDataSource(),
            stocksRemoteDataSource: DefaultStockRemoteDataSource()
        )
        
        logic.onDataFetched = { [weak self] stocksList in    // closure is executed when stock data(stocksList) is fetched and ready to be displayed.
            DispatchQueue.main.async {
                self?.stocksList = stocksList
                self?.stocksTableView.reloadData()
            }
        }
        
        logic.onStockDataFetched = { [weak self] ticker, stockResponse in
            stockPricesManager.saveStockPrices(ticker: ticker, stockResponse: stockResponse) {
                if let stockPrice = stockPricesManager.getStockPrices(ticker: ticker) {
                    self!.stockPrices[ticker] = stockResponse
                } else {
                    print("Stock data for \(ticker) not found in stockPrices")
                }
            }
        }
        logic.fetchStocks()  // when data is fetched, it triggers onDataFetched & onStockDataFetched
    }
}


extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 58
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.identifier, for: indexPath) as? MainTableViewCell else {return UITableViewCell()}
        
        if stocksList.isEmpty || indexPath.row >= stocksList.count {
            cell.configure(with: indexPath.row, companyName: "loading", companyTicker: "loading", currentPrice: 123, percentPrice: 123, priceChange: 123)
        } else {
            let imageURL = stocksList[indexPath.row].logo!
            let temporary_ticker = stocksList[indexPath.row].ticker
            cell.configure(with: indexPath.row, companyName: stocksList[indexPath.row].name, companyTicker: stocksList[indexPath.row].ticker, currentPrice: stockPrices[temporary_ticker]?.c ?? 12, percentPrice: stockPrices[temporary_ticker]?.dp ?? 12, priceChange: stockPrices[temporary_ticker]?.d ?? 12)
            Task {
                do {
                    if let image = try await defaultStockImageLoad.fetchImage(url: imageURL) {
                        DispatchQueue.main.async {
                            cell.logo.image = image
                        }
                    }
                } catch {
                    print("Error fetching image: \(error)")
                }
            }
//            stocksTableView.reloadData()
        }
        return cell
    }
}

extension MainViewController {
    
    private func setupTableView() {
        view.addSubview(stocksTableView)
        
        let stocksTableViewConstraints = [
            stocksTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stocksTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stocksTableView.topAnchor.constraint(equalTo: stocksButton.bottomAnchor, constant: 20),
            stocksTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ]
        NSLayoutConstraint.activate(stocksTableViewConstraints)
        
        stocksTableView.delegate = self
        stocksTableView.dataSource = self
        stocksTableView.separatorStyle = .none
    }
    
    private func setupButtons() {
        
        view.addSubview(stocksButton)
        view.addSubview(favoriteButton)
        
        let stocksButtonConstraints = [
            stocksButton.heightAnchor.constraint(equalToConstant: 32),
            stocksButton.widthAnchor.constraint(equalToConstant: 98),
            stocksButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stocksButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 36)
        ]
        let favoriteButtonConstraints = [
            favoriteButton.heightAnchor.constraint(equalToConstant: 32),
            favoriteButton.widthAnchor.constraint(equalToConstant: 98),
            favoriteButton.leadingAnchor.constraint(equalTo: stocksButton.trailingAnchor, constant: 20),
            favoriteButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 36)
        ]
        
        NSLayoutConstraint.activate(stocksButtonConstraints)
        NSLayoutConstraint.activate(favoriteButtonConstraints)
        
    }
}
