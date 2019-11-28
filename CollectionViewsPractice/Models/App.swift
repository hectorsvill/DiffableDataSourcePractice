//
//  App.swift
//  CollectionViewsPractice
//
//  Created by Hector on 11/28/19.
//  Copyright © 2019 Hector. All rights reserved.
//

import Foundation

struct App: Decodable, Hashable {
    let id: Int
    let tagline: String
    let name: String
    let subheading: String
    let image: String
    let iap: Bool
}
