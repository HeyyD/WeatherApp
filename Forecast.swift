//
//  ViewController.swift
//  WeatherApp
//
//  Created by Heidi Häti on 03/10/2018.
//  Copyright © 2018 Heidi Häti. All rights reserved.
//

import UIKit
import CoreLocation

class Forecast: UITableViewController, CLLocationManagerDelegate {
    
    let api_key = "a59dd893440fcb2c69b5fe347b9ef83c"
    let locationManager = CLLocationManager()
    
    var data : [WeatherForecastDTO] = []
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var weather: UILabel!
    @IBOutlet weak var time: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if AppDelegate.useGps {
            locationManager.requestLocation()
        } else {
            fetchUrl(url: "https://api.openweathermap.org/data/2.5/forecast?q=\(AppDelegate.selectedCity!)&units=metric&APPID=\(api_key)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            fetchUrl(url: "https://api.openweathermap.org/data/2.5/forecast?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&units=metric&APPID=\(api_key)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "weatherIdentifier")! as! ForecastCell
        
        let weather = data[indexPath.row].weather[0].description
        let time = data[indexPath.row].dt_txt
        let icon = data[indexPath.row].weather[0].icon
        
        cell.weather.text = weather
        cell.time.text = time
        
        let url = URL(string: "https://openweathermap.org/img/w/\(icon).png")!
        
        DispatchQueue.main.async (execute: { () in
            let data = NSData(contentsOf: url)!
            let image = UIImage(data: data as Data)
            cell.icon.image = image
        })
        
        return cell //4.
    }
    
    func fetchUrl(url : String) {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let url : URL? = URL(string: url)
        
        let task = session.dataTask(with: url!, completionHandler: doneFetching);
        
        // Starts the task, spawns a new thread and calls the callback function
        task.resume();
    }
    
    func doneFetching(data: Data?, response: URLResponse?, error: Error?) {
        // Execute stuff in UI thread
        DispatchQueue.main.async(execute: {() in
            let decoder = JSONDecoder()
            do {
                let forecast = try decoder.decode(ForecastDTO.self, from: data!)
                self.data = forecast.list
                self.tableView.reloadData()
            } catch {
                print("ERROR PARSING JSON")
            }
        })
    }
}
