//
//  Flickr.swift
//  ImageLookingFor
//
//  Created by Alexander Kolovatov on 07.01.18.
//  Copyright © 2018 Alexander Kolovatov. All rights reserved.
//

import UIKit

class Flickr {
    
    let apiKey = "33647e93ed5060b6ba4be8295bdfb31f"
    
    let processingQueue = OperationQueue()
    
    func searchFlickrForTerm(_ searchTerm: String, completion: @escaping (_ results: FlickrSearchResults?, _ error: NSError?) -> Void) {
        
        guard let searchURL = flickrSearchURLForSearchTerm(searchTerm) else {
            let APIError = NSError(domain: "FlickrSearch", code: 0, userInfo: [NSLocalizedFailureReasonErrorKey: "Unknown API response"])
            completion(nil, APIError)
            return
        }
        
        let searchRequest = URLRequest(url: searchURL)
        
        URLSession.shared.dataTask(with: searchRequest, completionHandler: { (data, response, error) in
            
            if let _ = error {
                let APIError = NSError(domain: "FlickrSearch", code: 0, userInfo: [NSLocalizedFailureReasonErrorKey:"Unknown API response"])
                OperationQueue.main.addOperation({
                    completion(nil, APIError)
                })
                return
            }
            
            guard let _ = response as? HTTPURLResponse,
                let data = data else {
                    let APIError = NSError(domain: "FlickrSearch", code: 0, userInfo: [NSLocalizedFailureReasonErrorKey:"Unknown API response"])
                    OperationQueue.main.addOperation({
                        completion(nil, APIError)
                    })
                    return
            }
            
            do {
                guard let resultsDictionary = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? [String: AnyObject],
                    let stat = resultsDictionary["stat"] as? String else {
                        
                        let APIError = NSError(domain: "FlickrSearch", code: 0, userInfo: [NSLocalizedFailureReasonErrorKey:"Unknown API response"])
                        OperationQueue.main.addOperation({
                            completion(nil, APIError)
                        })
                        return
                }
                
                switch stat {
                case "ok":
                    print("Results processed OK")
                case "fail":
                    if let message = resultsDictionary["message"] {
                        
                        let APIError = NSError(domain: "FlickrSearch", code: 0, userInfo: [NSLocalizedFailureReasonErrorKey: message])
                        
                        OperationQueue.main.addOperation({
                            completion(nil, APIError)
                        })
                    }
                    
                    let APIError = NSError(domain: "FlickrSearch", code: 0, userInfo: nil)
                    
                    OperationQueue.main.addOperation({
                        completion(nil, APIError)
                    })
                    
                    return
                default:
                    let APIError = NSError(domain: "FlickrSearch", code: 0, userInfo: [NSLocalizedFailureReasonErrorKey: "Unknown API response"])
                    OperationQueue.main.addOperation({
                        completion(nil, APIError)
                    })
                    return
                }
                
                guard let photosContainer = resultsDictionary["photos"] as? [String: AnyObject], let photosReceived = photosContainer["photo"] as? [[String: AnyObject]] else {
                    
                    let APIError = NSError(domain: "FlickrSearch", code: 0, userInfo: [NSLocalizedFailureReasonErrorKey: "Unknown API response"])
                    OperationQueue.main.addOperation({
                        completion(nil, APIError)
                    })
                    return
                }
                
                var flickrPhotos = [FlickrPhoto]()
                
                for photoObject in photosReceived {
                    guard let photoID = photoObject["id"] as? String,
                        let farm = photoObject["farm"] as? Int ,
                        let server = photoObject["server"] as? String ,
                        let secret = photoObject["secret"] as? String else {
                            break
                    }
                    let flickrPhoto = FlickrPhoto(photoID: photoID, farm: farm, server: server, secret: secret)
                    
                    guard let url = flickrPhoto.flickrImageURL(),
                        let imageData = try? Data(contentsOf: url as URL) else {
                            break
                    }
                    
                    if let image = UIImage(data: imageData) {
                        flickrPhoto.thumbnail = image
                        flickrPhotos.append(flickrPhoto)
                    }
                }
                
                OperationQueue.main.addOperation({
                    completion(FlickrSearchResults(searchTerm: searchTerm, searchResults: flickrPhotos), nil)
                })
                
            } catch _ {
                completion(nil, nil)
                return
            }
        }).resume()
    }
    
    fileprivate func flickrSearchURLForSearchTerm(_ searchTerm: String) -> URL? {
        
        guard let escapedTerm = searchTerm.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics) else {
            return nil
        }
        
        let URLString = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)&text=\(escapedTerm)&per_page=30&format=json&nojsoncallback=1"
        
        guard let url = URL(string: URLString) else {
            return nil
        }
        return url
    }
}
