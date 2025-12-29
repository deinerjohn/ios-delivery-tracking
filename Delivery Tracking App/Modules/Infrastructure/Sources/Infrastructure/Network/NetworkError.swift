//
//  NetworkError.swift
//  Infrastructure
//
//  Created by Deiner John Calbang on 12/29/25.
//

import Foundation

enum NetworkError: Error {
    
    case invalidUrl
    case noResponse
    case decodeError
    case unexpectedStatusCode
    case unknown
    case cancelledRequest
    
    var debugDescription: String {
        switch self {
        default:
            return "ADD custom debug description"
        }
    }
    
}
