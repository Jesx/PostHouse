//
//  Api.swift
//  PostHouse
//
//  Created by Jes Yang on 2019/11/25.
//  Copyright © 2019 Jes Yang. All rights reserved.
//

import Foundation
import UIKit

let urlAPI = "http://35.229.230.23"
var token = ""

enum Station: String {
    case Athens = "雅典"
    case Phokis = "菲基斯"
    case Arkadia = "阿卡迪亞"
    case Sparta = "斯巴達"

    var id: Int {
        switch self {
        case .Athens: return 1
        case .Phokis: return 2
        case .Arkadia: return 3
        case .Sparta: return 4
        }
    }
    
    var color: UIColor {
        switch self {
        case .Athens: return #colorLiteral(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1)
        case .Phokis: return #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        case .Arkadia: return #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        case .Sparta: return #colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 1)
        }
    }
    
    var foregroundColor: UIColor {
        switch self {
        case .Athens: return #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        case .Phokis: return #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
        case .Arkadia: return #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        case .Sparta: return #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)
        }
    }
}

struct RegisterUser: Codable {
    let role: String
    let username: String
    let password: String
}

struct LoginUser:  Codable {
    let username: String
    let password: String
}

struct LoginResponse: Codable {
    let message: String
    let data: Data?
    
    struct Data: Codable {
        let username: String
        let api_token: String
    }
}

struct Freight: Codable {
    let name: String
    let description: String
    let weight: Int
    let des_station_name: String
    let start_station_name: String
    let price: Int
}

struct FreightResponse: Codable {
    let message: String
    let data: Data
    
    struct Data: Codable {
        let name: String
        let description: String
        let weight: Int
        let price: Int
        let status: String
        let id: Int
    }
}

struct GetStation: Codable {
    let data: [Data]
    
    struct Data: Codable {
        let id: Int
        let name: String
    }
}

struct GetFreight: Codable {
    let message: String
    let data: [Data]
    
    struct Data: Codable {
        let name: String
        let description: String
        let weight: Int
        let price: Int
        let status: String
        let photo_url: String?
        let start_station: Station
        let des_station: Station
        let now_station: Station
        
        struct Station: Codable {
            let name: String
        }
    }
}

struct GetStationLevel: Codable {
    let data: [Data]
    
    struct Data: Codable {
        let id: Int
        let name: String
        let level: Int
        let totalWeight: Float
        let income: Int
    }
}

class PostHouseData {
    
    // MARK: - Login
    func login(username: String, password: String, completion: @escaping (LoginResponse) -> Void) {
        
        let loginUser = LoginUser(username: username, password: password)
        
        guard let uploadData = try? JSONEncoder().encode(loginUser) else {
            return
        }
        
        let url = URL(string: "\(urlAPI)/api/login")!
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        
        request.setValue("keep-alive", forHTTPHeaderField: "Connection")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.uploadTask(with: request, from: uploadData) { data, response, error in
            
            if let error = error {
                print ("error: \(error)")
                return
            } else {
                print ("Upload successed.")
            }
            
            guard let response = response as? HTTPURLResponse,
                (200...410).contains(response.statusCode) else {
                    print ("server error")
                    return
            }
            
            if let mimeType = response.mimeType,
                mimeType == "application/json",
                let data = data {
                
                do {
                    let responseData = try JSONDecoder().decode(LoginResponse.self, from: data)
                    completion(responseData)
                    
                } catch let jsonErr {
                    
                    print("Error serialization json: \(jsonErr)")
                }
            }
        }
        
        task.resume()
    }
    
    // MARK: - Sign Up
    func signUp(role: String, username: String, password: String, completion: @escaping () -> Void) {
        
        let loginUser = RegisterUser(role: role, username: username, password: password)
        
        guard let uploadData = try? JSONEncoder().encode(loginUser) else {
            return
        }
        
        let url = URL(string: "\(urlAPI)/api/register")!
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        
        request.setValue("keep-alive", forHTTPHeaderField: "Connection")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.uploadTask(with: request, from: uploadData) { data, response, error in
            
            if let error = error {
                print ("error: \(error)")
                return
            } else {
                print ("Upload successed.")
            }
            
            guard let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode) else {
                    print ("server error")
                    return
            }
            
            completion()
            
        }
        
        task.resume()
    }
    
    // MARK: - Upload A Freight
    func uploadFreight(name: String, description: String, weight: Int, desStation: String, startStation: String, price: Int, completion: @escaping (FreightResponse) -> Void) {
        
        let freight = Freight(name: name, description: name, weight: weight, des_station_name: desStation, start_station_name: startStation, price: price)
        
        guard let uploadData = try? JSONEncoder().encode(freight) else {
            return
        }
        
        let url = URL(string: "\(urlAPI)/api/goods")!
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        
        request.setValue("keep-alive", forHTTPHeaderField: "Connection")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.uploadTask(with: request, from: uploadData) { data, response, error in
            
            if let error = error {
                print ("error: \(error)")
                return
            } else {
                print ("Upload successed.")
            }
            
            guard let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode) else {
                    print ("server error")
                    return
            }
            
            if let mimeType = response.mimeType,
                mimeType == "application/json",
                let data = data {
                
                do {
                    let responseData = try JSONDecoder().decode(FreightResponse.self, from: data)
                    completion(responseData)
                    
                } catch let jsonErr {
                    
                    print("Error serialization json: \(jsonErr)")
                }
            }
            
        }
        
        task.resume()
    }
    
    func getStation(completion: @escaping (GetStation) -> Void) {

        let url = URL(string: "\(urlAPI)/api/stations")!

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        request.setValue("keep-alive", forHTTPHeaderField: "Connection")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in

            if error != nil {
                print(error!.localizedDescription)
                return
            }

            guard let response = response as? HTTPURLResponse,
                (200...400).contains(response.statusCode) else {
                    print ("server error")
                    return
            }

            guard let data = data else { return }

            do {
                let getStations = try JSONDecoder().decode(GetStation.self, from: data)
                completion(getStations)

            } catch let jsonErr {
                print("Error serialization json: \(jsonErr)")
            }
        }

        task.resume()
    }
    
    // MARK: - Get Freights
    func getFreights(completion: @escaping (GetFreight) -> Void) {

        let url = URL(string: "\(urlAPI)/api/goods")!

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        request.setValue("keep-alive", forHTTPHeaderField: "Connection")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in

            if error != nil {
                print(error!.localizedDescription)
                return
            }

            guard let response = response as? HTTPURLResponse,
                (200...400).contains(response.statusCode) else {
                    print ("server error")
                    return
            }

            guard let data = data else { return }

            do {
                let getStations = try JSONDecoder().decode(GetFreight.self, from: data)
                completion(getStations)

            } catch let jsonErr {
                print("Error serialization json: \(jsonErr)")
            }
        }

        task.resume()
    }
    
    // MARK: - Get Station Level
    func getStationLevel(completion: @escaping (GetStationLevel) -> Void) {

        let url = URL(string: "\(urlAPI)/api/stations")!

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        request.setValue("keep-alive", forHTTPHeaderField: "Connection")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in

            if error != nil {
                print(error!.localizedDescription)
                return
            }

            guard let response = response as? HTTPURLResponse,
                (200...400).contains(response.statusCode) else {
                    print ("server error")
                    return
            }

            guard let data = data else { return }

            do {
                let getStations = try JSONDecoder().decode(GetStationLevel.self, from: data)
                completion(getStations)

            } catch let jsonErr {
                print("Error serialization json: \(jsonErr)")
            }
        }

        task.resume()
    }

    
    // Use formdata to upload // parameters: [String: Any], dataPath: [String: Data],
    func uploadImageWithFormData(goodId: Int, image: UIImage, completion: @escaping (Data) -> Void){
        
        let url = URL(string: "\(urlAPI)/api/image")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.setValue("keep-alive", forHTTPHeaderField: "Connection")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let boundary = "Boundary+\(arc4random())\(arc4random())"
        var body = Data()
        
        let uploadData = image.jpegData(compressionQuality: 0.5)
        
        let parameters : [String : Int] = ["good_id" : goodId]
        let dataPath : [String: Data] = ["photo" : uploadData!]
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        for (key, value) in parameters {
            body.appendString(string: "--\(boundary)\r\n")
            body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString(string: "\(value)\r\n")
        }
        
        for (key, value) in dataPath {
            body.appendString(string: "--\(boundary)\r\n")
            //此處放入file name，以隨機數代替，可自行放入
            body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(arc4random())\"\r\n")
            //image/png 可改為其他檔案類型 ex:jpeg
            body.appendString(string: "Content-Type: image/jpeg\r\n\r\n")
            body.append(value)
            body.appendString(string: "\r\n")
        }
        
        body.appendString(string: "--\(boundary)--\r\n")
        request.httpBody = body
        
        fetchedDataByDataTask(from: request, completion: completion)
        
    }
    
    private func fetchedDataByDataTask(from request: URLRequest, completion: @escaping (Data) -> Void){
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if error != nil {
                print(error as Any)
            } else {
                guard let data = data else { return }
                completion(data)
            }

        }
        task.resume()
    }

}

extension Data {
    
    mutating func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}
