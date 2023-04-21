//
//  Advice.swift
//  AdviceProvider
//
//  Created by Zaid Ragab on 2023-04-20.
//

import Foundation

struct Advice: Decodable, Hashable, Encodable {
    let slip: Slip
}

struct Slip: Decodable, Hashable, Encodable {
    let id: Int
    let advice: String
}
