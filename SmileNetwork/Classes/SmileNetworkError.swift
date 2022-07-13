//
//  SmileError.swift
//  SmileNetwork
//
//  Created by laziestlee on 2022/7/12.
//

import Foundation

public enum SmileNetworkError: Error {
    case decode
    case invalidURL
    case offLine
    case unauthorized
    case custom(msg: String?)
    case unknown

    public var message: String {
        switch self {
            case .offLine:
                return "无网络"
            case .invalidURL:
                return "路径不合法"
            case .decode:
                return "解析异常"
            case .unauthorized:
                return "未授权"
            case let .custom(msg: message):
                return message ?? "未知错误"
            default:
                return "未知错误"
        }
    }
}
