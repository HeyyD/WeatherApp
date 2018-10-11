class ForecastDTO: Codable {
    var city: City
    var list: [WeatherForecastDTO] = []
}

struct WeatherForecastDTO: Codable {
    var main: Main
    var weather: [WeatherDescriptionDTO]
    var dt_txt: String
}

struct City: Codable {
    var name: String
}
