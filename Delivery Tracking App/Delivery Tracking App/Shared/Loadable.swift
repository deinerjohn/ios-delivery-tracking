//
//  Loadable.swift
//  Delivery Tracking App
//
//  Created by Deiner John Calbang on 12/29/25.
//

import Foundation

enum Loadable<T: Equatable>: Equatable {
    case idle
    case loading
    case loaded(T)
    case empty
    case error(String)
}
