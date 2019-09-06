//
//  Trip.swift
//  Serialization
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
            
            let (trip, error) = parseTrip(data: data)
            DispatchQueue.main.async {
                completionHandler(trip, error)
            }
        }
        
        task.resume()
    }
}

func parseTrip(data: Data) -> (Trip?, String?) {
    var status = ""
    var photosPath = ""
    var photos = [Photo]()
    
    do {
        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary,
            let statusItem = json["status"] as? String {
            if (statusItem != "ok") {
                return (nil, "status was not ok")
            }
            status = statusItem
            
            guard let photosPathItem = json["photosPath"] as? String else {
                return (nil, "photosPath could not be determined")
            }
            photosPath = photosPathItem
            
            guard let photoList = json["photos"] as? [NSDictionary] else {
                return (nil, "photos could not be retrieved")
            }
            
            for photoItem in photoList {
                if let image = photoItem["image"] as? String,
                   let title = photoItem["title"] as? String,
                   let description = photoItem["description"] as? String,
                   let latitude = photoItem["latitude"] as? Double,
                   let longitude = photoItem["longitude"] as? Double,
                   let date = photoItem["date"] as? String {
                        let photo = Photo(image: image, title: title, description: description, latitude: latitude, longitude: longitude, date: date)
                        photos.append(photo)
                } else {
                    return (nil, "photo is invalid")
                }
            }
        }
        
    } catch let parseError {
        return (nil, parseError.localizedDescription)
    }
    
    let trip = Trip(status: status, photosPath: photosPath, photos: photos)
    return (trip, nil)
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
