//
//  Service.swift
//  gowabi_test
//
//  Created by Francis Myat on 9/23/22.
//

import Foundation

struct Service: Codable {
     
    let id, currency_id, price: Int?
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, currency_id, price
    }
    
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(Service.self, from: data) else { return nil }
        self = me
    }
    
    init(id: Int?, currency_id: Int?, name: String?, price: Int?) {
        self.id = id
        self.currency_id = currency_id
        self.name = name
        self.price = price
    }
}
