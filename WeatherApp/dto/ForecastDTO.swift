struct ForecastDTO: Codable {
    var list: [WeatherForecastDTO]
}

struct WeatherForecastDTO: Codable {
    var main: Main
    var weather: [WeatherDescriptionDTO]
    var dt_txt: String
}
