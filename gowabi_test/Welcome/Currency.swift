//
//  Currency.swift
//  gowabi_test
//
//  Created by Francis Myat on 9/22/22.
//

import Foundation

struct Currency: Codable {
    
    let id: Int?
    let label: String?

    enum CodingKeys: String, CodingKey {
        case id, label
    }
    
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(Currency.self, from: data) else { return nil }
        self = me
    }
}
