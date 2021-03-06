//
//  TrailManager.swift
//  Trilheiros
//
//  Created by Laila Guzzon Hussein Lailota on 22/09/21.
//

import Foundation
import Alamofire
import CoreLocation
import RealmSwift

protocol TrailControllerProtocol: AnyObject {
    
    func success()
    func failed(error: Error)
}

class TabBarController {
    
    var trails: [Datum] = []
    var filterTrails: [Datum] = []
    let persistence = TrailsPersistence()
    
    private weak var delegate: TrailControllerProtocol?
    
    func loadCurrentTrail(indexPath: IndexPath) -> Datum {
        return self.trails[indexPath.row]
    }
    
    func setupDelegate(delegate: TrailControllerProtocol?) {
        self.delegate = delegate
    }
    
    var count: Int {
        return self.trails.count
    }
    
    func loadTrail(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let headers: HTTPHeaders = [
            "x-rapidapi-host": "trailapi-trailapi.p.rapidapi.com",
            "x-rapidapi-key": "bedf462ca4msha8203d2d0bfd00ep15cd01jsn8a29b10580e4"
        ]
         
        AF.request("https://trailapi-trailapi.p.rapidapi.com/trails/explore/?lat=\(String(latitude))&lon=\(String(longitude))&per_page=50&radius=25", headers: headers).responseJSON { response in
            
            if response.response?.statusCode == 200 {
                
                if let data = response.data {
                    
                    do {
                        guard let result: Trail? = try JSONDecoder().decode(Trail.self, from: data) else { return }
                        
                        self.trails = Array(result!.data)
                        self.filterTrails = self.trails
                        
                       
                        self.delegate?.success()
                        
                    } catch {
                        
                        self.delegate?.failed(error: error)
                        print(error)
                    }
                }
            } else {
                print("Deu error")
            }
        }
    }
}
