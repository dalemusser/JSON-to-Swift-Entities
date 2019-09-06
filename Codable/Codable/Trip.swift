//
//  Photos.swift
//  Codable
//
//  Created by Dale Musser on 9/6/19.
//  Copyright © 2019 Dale Musser. All rights reserved.
//

import Foundation

class TripLoader {
    class func load(urlString: String, completionHandler: @escaping (Trip?, String?) -> Void ) {
        guard let url = URL(string: urlString) else {
            DispatchQueue.main.async {
                completionHandler(nil, "The URL string could not be converted into a URL.")
            }
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    completionHandler(nil, error.localizedDescription)
                }
                return
            }
           
            guard let data = data else {
                DispatchQueue.main.async {
                    completionHandler(nil, "Unable to access returned data.")
                }
                return
            }
           
            do {
                let decoder = JSONDecoder()
                let photos = try decoder.decode(Trip.self, from: data)
                DispatchQueue.main.async {
                    completionHandler(photos, nil)
                }
            } catch let decodeError {
                DispatchQueue.main.async {
                    completionHandler(nil, decodeError.localizedDescription)
                }
                return
            }
        }
        
        task.resume()
    }
}

struct Trip: Codable {
    let status: String
    let photosPath: String
    var photos: [Photo]
}

struct Photo: Codable {
    let image: String
    let title: String
    let description: String
    let latitude: Double
    let longitude: Double
    let date: String
}
