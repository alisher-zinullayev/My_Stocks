//
//  StockMetaData.swift
//  MyStocks_Final
//
//  Created by Alisher Zinullayev on 07.09.2023.
//

import Foundation

struct StockMetaData: Codable {
    let name: String
    let logo: URL?
    let ticker: String

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.ticker = try container.decode(String.self, forKey: .ticker)
        let logoString = try container.decode(String.self, forKey: .logo)
        self.logo = URL(string: logoString)
    }

    private enum CodingKeys: String, CodingKey {
        case name, logo, ticker
    }
}
