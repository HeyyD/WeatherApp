struct ForecastDTO: Codable {
    var list: [WeatherForecastDTO]
}

struct WeatherForecastDTO: Codable {
    var main: Main
    var weather: [WeatherDescriptionDTO]
    var dt_txt: String
}

struct WeatherDescriptionDTO: Codable {
    var main : String
    var description : String
    var icon : String
}
