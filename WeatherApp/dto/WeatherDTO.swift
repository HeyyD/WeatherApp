class WeatherDTO: Codable {
    var id: Int
    var name: String
    var main: Main
    var weather: [WeatherDescriptionDTO] = []
}
