//
//  ViewController.swift
//  Codable
//
//  Created by Dale Musser on 9/6/19.
//  Copyright © 2019 Dale Musser. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let urlString = "https://dalemusser.com/code/examples/data/nocaltrip/photos.json"

    override func viewDidLoad() {
        super.viewDidLoad()
    
        TripLoader.load(urlString: urlString) {
            (trip, error) in
            
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            guard let trip = trip else {
                print("Unable to unwrap trip.")
                return
            }
            
            print("status: \(trip.status)")
            print("photosPath: \(trip.photosPath)")
            print("count of photos: \(trip.photos.count)")
            for photo in trip.photos {
                print("--------------------------------------")
                print("image: \(photo.image)")
                print("title: \(photo.title)")
                print("description: \(photo.description)")
                print("latitude: \(photo.latitude)")
                print("longitude: \(photo.longitude)")
                print("date: \(photo.date)")
            }
        }
    }


}

