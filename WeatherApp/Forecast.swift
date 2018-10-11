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
    var imageData: Dictionary<String, NSData> = Dictionary<String, NSData>()
    
    let indicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        let bounds = UIScreen.main.bounds;
        
        indicator.center = CGPoint(x: bounds.width/2, y: bounds.height/2)
        indicator.frame = bounds
        indicator.backgroundColor = UIColor.black
        indicator.alpha = 0.5
        indicator.hidesWhenStopped = true;
        
        self.tableView.backgroundView = indicator
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        indicator.startAnimating()
        self.data = []
        tableView.reloadData()
        
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
        let temp = data[indexPath.row].main.temp
        let time = data[indexPath.row].dt_txt
        let icon = data[indexPath.row].weather[0].icon
        
        cell.weather.text = "\(weather) \(temp)C"
        cell.time.text = time
        
        DispatchQueue.main.async (execute: { () in
            
            let data: NSData
            
            if self.imageData.keys.contains(icon) {
               data = self.imageData[icon]!
            } else {
                let url = URL(string: "https://openweathermap.org/img/w/\(icon).png")!
                data = NSData(contentsOf: url)!
                self.imageData[icon] = data
            }
            
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
            
            self.indicator.stopAnimating()
        })
    }
}
