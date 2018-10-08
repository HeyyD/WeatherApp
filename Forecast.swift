//
//  ViewController.swift
//  WeatherApp
//
//  Created by Heidi Häti on 03/10/2018.
//  Copyright © 2018 Heidi Häti. All rights reserved.
//

import UIKit

class Forecast: UITableViewController {
    
    let api_key = "a59dd893440fcb2c69b5fe347b9ef83c"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUrl(url: "https://api.openweathermap.org/data/2.5/forecast?q=\(AppDelegate.selectedCity)&units=metric&APPID=\(api_key)")
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                print(forecast)
            } catch {
                print(error)
            }
        })
    }
}
