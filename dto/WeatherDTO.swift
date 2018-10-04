
struct WeatherDTO: Codable {
    var id: Int
    var name: String
    var main: Main
}

struct Main: Codable {
    var temp: Float
}
