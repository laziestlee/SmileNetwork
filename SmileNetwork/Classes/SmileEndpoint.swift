//
//  SmileEndpoint.swift
//  SmileNetwork
//
//  Created by laziestlee on 2022/7/12.
//

import Foundation

public protocol SmileEndpoint {
    var baseURL: String { get }
    var path: String { get }
    var method: SmileNetworkMethod { get }
    var header: [String: String]? { get }
    var queryParams: [String: String]? { get }
    var body: [String: String]? { get }
}

