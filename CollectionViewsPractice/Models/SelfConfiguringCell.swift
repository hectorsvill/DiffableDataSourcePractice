//
//  SelfConfiguringCell.swift
//  CollectionViewsPractice
//
//  Created by Hector on 12/1/19.
//  Copyright © 2019 Hector. All rights reserved.
//

import Foundation
protocol SelfConfiguringCell {
    static var reuseIdentifier: String { get }
    func configure(with app: App)
}
