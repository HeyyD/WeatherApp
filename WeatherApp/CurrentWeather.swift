//
//  ViewController.swift
//  WeatherApp
//
//  Created by Heidi Häti on 03/10/2018.
//  Copyright © 2018 Heidi Häti. All rights reserved.
//

import UIKit
import CoreLocation

class CurrentWeather: UIViewController, CLLocationManagerDelegate {
    
    let api_key = "a59dd893440fcb2c69b5fe347b9ef83c"
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        indicator.startAnimating()
        
        if AppDelegate.useGps {
            locationManager.requestLocation()
        } else {
            fetchUrl(url: "https://api.openweathermap.org/data/2.5/weather?q=\(AppDelegate.selectedCity!)&units=metric&APPID=" + api_key)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            fetchUrl(url: "https://api.openweathermap.org/data/2.5/weather?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&units=metric&APPID=\(api_key)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
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
                let weather = try decoder.decode(WeatherDTO.self, from: data!)
                self.city.text = weather.name
                self.temperature.text = String(weather.main.temp) + " C"
                
                let icon = weather.weather[0].icon
                
                let url = URL(string: "https://openweathermap.org/img/w/\(icon).png")!
                
                let data = NSData(contentsOf: url)!
                let image = UIImage(data: data as Data)
                self.icon.image = image
                
            } catch {
                print("ERROR PARSING JSON")
            }
            
            self.indicator.stopAnimating()
        })
    }
    
}

