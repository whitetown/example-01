//
//  API.swift
//  example-01
//
//  Created by Sergey Chehuta on 21/05/2020.
//  Copyright © 2020 WhiteTown. All rights reserved.
//

import UIKit

class API {
    
    func getMovies(_ completion: @escaping ((Result<[Movie],Error>)->Void)) {
        weak var welf = self
        if let moviesUrl = URL(string: Mock.movies) {
            URLSession.shared.dataTask(with: moviesUrl,
                                       completionHandler: { [weak self] (data, response, error) in
                                   
                    if let error = error {
                        if let data = self?.readData() {
                            completion(.success(welf?.parse(data) ?? []))
                        } else {
                            completion(.failure(error))
                        }
                    } else {
                        self?.saveData(data)
                        completion(.success(welf?.parse(data) ?? []))
                    }
            }).resume()
        } else {
            completion(.success([]))
        }
    }
    
    static func getImageFromURL(_ url: URL, _ completion: @escaping (_ image: UIImage?, _ url: URL) -> Void) {
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { (data, response, error) in
            
            if let _ = error {
                completion(nil, url)
            } else {
                
                if let _ = response as? HTTPURLResponse {
                    if let imageData = data {
                        let image = UIImage(data: imageData)
                        completion(image, url)
                    } else {
                        completion(nil, url)
                    }
                } else {
                    completion(nil, url)
                }
            }
        }
        
        task.resume()

    }
    
    private func parse(_ data: Data?) -> [Movie] {

        if  let data = data {
            let decoder = JSONDecoder()
            let result  = try? decoder.decode([Movie].self, from: data)
            return result ?? []
        } else {
            return []
        }
    }
    
    private func file() -> URL? {
        guard let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else { return nil }
//        print(dir)
        return dir.appendingPathComponent("movies.json")
    }

    private func saveData(_ data: Data?) {
        if let url = file() {
            try? data?.write(to: url, options: .atomic)
        }
    }
    
    private func readData() -> Data? {
        if let url = file() {
            return try? Data(contentsOf: url)
        }
        return nil
    }
}
