//
//  Weather.swift
//  SmileNetwork_Example
//
//  Created by laziestlee on 2022/7/13.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation

// MARK: - WeatherResponse
struct WeatherResponse: Codable, Equatable {
    let message: String
    let status: Int
    let date: String
    let time: String
    let cityInfo: CityInfo
    let data: DataClass

    enum CodingKeys: String, CodingKey {
        case message = "message"
        case status = "status"
        case date = "date"
        case time = "time"
        case cityInfo = "cityInfo"
        case data = "data"
    }
}


// MARK: - CityInfo
struct CityInfo: Codable, Equatable {
    let city: String
    let citykey: String
    let parent: String
    let updateTime: String

    enum CodingKeys: String, CodingKey {
        case city = "city"
        case citykey = "citykey"
        case parent = "parent"
        case updateTime = "updateTime"
    }
}



// MARK: - DataClass
struct DataClass: Codable, Equatable {
    let shidu: String
    let pm25: Int
    let pm10: Int
    let quality: String
    let wendu: String
    let ganmao: String
    let forecast: [Yesterday]
    let yesterday: Yesterday

    enum CodingKeys: String, CodingKey {
        case shidu = "shidu"
        case pm25 = "pm25"
        case pm10 = "pm10"
        case quality = "quality"
        case wendu = "wendu"
        case ganmao = "ganmao"
        case forecast = "forecast"
        case yesterday = "yesterday"
    }
}


// MARK: - Yesterday
struct Yesterday: Codable, Equatable {
    let date: String
    let high: String
    let low: String
    let ymd: String
    let week: String
    let sunrise: String
    let sunset: String
    let aqi: Int
    let fx: String
    let fl: String
    let type: String
    let notice: String

    enum CodingKeys: String, CodingKey {
        case date = "date"
        case high = "high"
        case low = "low"
        case ymd = "ymd"
        case week = "week"
        case sunrise = "sunrise"
        case sunset = "sunset"
        case aqi = "aqi"
        case fx = "fx"
        case fl = "fl"
        case type = "type"
        case notice = "notice"
    }
}
