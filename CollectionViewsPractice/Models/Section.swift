//
//  Section.swift
//  CollectionViewsPractice
//
//  Created by Hector on 11/28/19.
//  Copyright © 2019 Hector. All rights reserved.
//

import Foundation

struct Section: Decodable, Hashable {
    let id: Int
    let type: String
    let title: String
    let subtitle: String
    let items: [App]
}
