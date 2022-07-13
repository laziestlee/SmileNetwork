# SmileNetwork
A Swift network utility with async/await applied

# UseAge

```Swift
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
        return nil
    }

    var body: [String: String]? {
        return nil
    }
}

protocol WeatherServiceAble {
    func requestWeather(cityId: String) async -> Result<WeatherResponse, SmileNetworkError>
}

struct WeatherService: WeatherServiceAble, SmileNetwork {
    func requestWeather(cityId: String) async -> Result<WeatherResponse, SmileNetworkError> {
        return await sendRequest(endPoint: MockEndpoint.weather(cityId: cityId), responseType: WeatherResponse.self)
    }
}

/// Request
let api = WeatherService()
Task {
    let resut = await api.requestWeather(cityId: "101030100")
    switch resut {
        case let .success(text):
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
```