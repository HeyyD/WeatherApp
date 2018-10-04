//
//  ViewController.swift
//  WeatherApp
//
//  Created by Heidi Häti on 03/10/2018.
//  Copyright © 2018 Heidi Häti. All rights reserved.
//

import UIKit

class Cities: UITableViewController {
    
    private var data: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Location"
        
        data.append("Use GPS")
        data.append("Helsinki")
        data.append("Tampere")
        
        tableView.dataSource = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier")! //1.
        
        let text = data[indexPath.row] //2.
        
        cell.textLabel?.text = text //3.
        
        return cell //4.
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(data[indexPath[1]])
        AppDelegate.selectedCity = data[indexPath[1]]
    }
}

