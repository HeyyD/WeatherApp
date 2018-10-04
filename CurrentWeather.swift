//
//  ViewController.swift
//  WeatherApp
//
//  Created by Heidi Häti on 03/10/2018.
//  Copyright © 2018 Heidi Häti. All rights reserved.
//

import UIKit

class CurrentWeather: UIViewController {
    
    let api_key = "a59dd893440fcb2c69b5fe347b9ef83c"
    
    let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var temperature: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Current weather"
        
        let bounds = UIScreen.main.bounds
        indicator.center = CGPoint(x: bounds.width/2, y: bounds.height/2)
        self.view.addSubview(indicator)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchUrl(url: "https://api.openweathermap.org/data/2.5/weather?q=\(AppDelegate.selectedCity)&units=metric&APPID=" + api_key)
    }
    
    func fetchUrl(url : String) {
        indicator.startAnimating()
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let url : URL? = URL(string: url)
        
        let task = session.dataTask(with: url!, completionHandler: doneFetching);
        
        // Starts the task, spawns a new thread and calls the callback function
        task.resume();
    }
    
    func doneFetching(data: Data?, response: URLResponse?, error: Error?) {
        let resstr = String(data: data!, encoding: String.Encoding.utf8)
        
        // Execute stuff in UI thread
        DispatchQueue.main.async(execute: {() in
            NSLog(resstr!)
            self.indicator.stopAnimating()
            
            let decoder = JSONDecoder()
            do {
                let weather = try decoder.decode(WeatherDTO.self, from: data!)
                self.city.text = weather.name
                self.temperature.text = String(weather.main.temp) + " C"
            } catch {
                print("ERROR PARSING JSON")
            }
        })
    }
    
}
