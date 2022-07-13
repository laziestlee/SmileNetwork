//
//  ViewController.swift
//  SmileNetwork
//
//  Created by laziestlee on 07/12/2022.
//  Copyright (c) 2022 laziestlee. All rights reserved.
//

import SmileNetwork
import UIKit

enum MockEndpoint {
    case weather(cityId: String)
}

extension MockEndpoint: SmileEndpoint {
    var baseURL: String {
        return "http://t.weather.sojson.com/"
    }

    var path: String {
        switch self {
            case let .weather(cityId):
                return "api/weather/city/\(cityId)"
        }
    }

    var method: SmileNetworkMethod {
        return .get
    }

    var header: [String: String]? {
        return ["Content-Type": "application/json;charset=utf-8"]
    }

    var queryParams: [String: String]? {
        switch self {
            case .weather:
                return nil
        }
    }

    var body: [String: String]? {
        return nil
    }
}

struct Mine: Codable {
    let name: String
    
    enum CodingKeys: String, CodingKey {
          case name
      }
}


protocol HomeMineServiceAble {
    /// 天气数据
    func requestWeather(cityId: String) async -> Result<WeatherResponse,SmileNetworkError>
    
}


struct HomeMineService: HomeMineServiceAble,SmileNetwork {

    
    func requestWeather(cityId: String) async -> Result<WeatherResponse, SmileNetworkError> {
        return await sendRequest(endPoint: MockEndpoint.weather(cityId: cityId), responseType: WeatherResponse.self)
    }

    
    
}

class ViewController: UIViewController {
    
    let api = HomeMineService()

    lazy var label: UILabel = {
        let lab = UILabel()
        lab.font = UIFont.systemFont(ofSize: 18)
        lab.textColor = .brown
        lab.numberOfLines = 0
        return lab
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
        view.addSubview(label)
        label.frame = CGRect(x: 15, y: 120, width: view.bounds.width - 30, height: 300)
    
        let homeBtn = UIButton(type: .contactAdd)
        homeBtn.setTitle("获取天气情况", for: .normal)
        homeBtn.addTarget(self, action: #selector(self.home), for: .touchUpInside)
        view.addSubview(homeBtn)
        homeBtn.frame = CGRect(x: 100, y: label.frame.maxY + 40, width: 200, height: 44)
        
    }
    
    
    @objc func home()  {
        Task{
            let resut = await api.requestWeather(cityId: "101030100")
             switch resut {
                 case let .success( text):
                     let city = "城市： \(text.cityInfo.city)\n"
                     let shidu = "湿度： \(text.data.shidu)\n"
                     let pm25 = "PM2.5： \(text.data.pm25)\n"
                     let pm10 = "PM10： \(text.data.pm10)\n"
                     let wendu = "温度： \(text.data.wendu)°C\n"
                     label.text = city + shidu + pm25 + pm10 + wendu
                 case let .failure(error):
                     label.text = error.localizedDescription
             }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
