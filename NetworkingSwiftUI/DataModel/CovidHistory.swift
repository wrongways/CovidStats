//
//  Results.swift
//  NetworkingSwiftUI
//
//  Created by jez wain on 8/26/20.
//  Copyright © 2020 jez wain. All rights reserved.
//

import Foundation

struct DailyCovidStats: Codable, Identifiable {
    
    let date: Int
    let nStates: Int
    let positive: Int
    let negative: Int
    let hospitalizedCurrently: Int?
//    let hospitalizedCumulative: Int
//    let inIcuCurrently: Int
//    let inIcuCumulative: Int
//    let recovered: Int
    let id: String
    
    
    // Map the json "hash" entry to our "id" attribute
    enum CodingKeys: String, CodingKey {
        case date
        case nStates = "states"
        case positive
        case negative
        case hospitalizedCurrently
        case id = "hash"
    }
}


class ResultsModel: ObservableObject {
    @Published var covidHistory = [DailyCovidStats]()
}
