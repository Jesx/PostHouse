//
//  Api.swift
//  PostHouse
//
//  Created by Jes Yang on 2019/11/25.
//  Copyright © 2019 Jes Yang. All rights reserved.
//

import UIKit

let urlAPI = "http://35.229.230.23"
var token = ""

struct RegisterUser: Codable {
    let role: String
    let username: String
    let password: String
}

struct RegisterUserResponse: Codable {
    let role: String?
    let username: String?
    let password: String?
    let message: username?
    
    struct username: Codable {
        let username: [String]
    }
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
        let role_name: String
    }
}

struct Freight: Codable {
    let name: String
    let description: String
    let weight: Float
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
        let weight: Float
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
    let data: [FreightData]
    
    struct FreightData: Codable {
        let name: String
        let description: String
        let weight: Float
        let price: Int
        let status: String
        let photo_url: String?
        let start_station: Station
        let des_station: Station
        let now_station: Station
        
        struct Station: Codable {
            let name: String
        }
        
//        var image: UIImage? {
//            if let url = photo_url, let photoUrl = URL(string: url) {
//                if let data = try? Data(contentsOf: photoUrl) {
//                    return UIImage(data: data)
//                }
//            }
//            return nil
//        }
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
    func signUp(role: String, username: String, password: String, completion: @escaping (RegisterUserResponse) -> Void) {
        
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
                (200...410).contains(response.statusCode) else {
                    print ("server error")
                    return
            }
            
            if let mimeType = response.mimeType,
                mimeType == "application/json",
                let data = data {
                
                do {
                    let responseData = try JSONDecoder().decode(RegisterUserResponse.self, from: data)
                    completion(responseData)
                    
                } catch let jsonErr {
                    
                    print("Error serialization json: \(jsonErr)")
                }
            }
        }
        
        task.resume()
    }
    
    
    // MARK: - Upload A Freight
    func uploadFreight(name: String, description: String, weight: Float, desStation: String, startStation: String, price: Int, completion: @escaping (FreightResponse) -> Void) {
        
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


// MARK: - Data for Runner

struct TaskList: Codable {
    let message: String
    let data: [TaskListData]
    
    struct TaskListData: Codable {
        let id: Int
        let status: String
        let good_name: String
        let start_station_name: String
        let des_station_name: String
        let weight: Float
        let price: Int
        let photo_url: String?
        
//        var image: UIImage? {
//            if let url = photo_url, let photoUrl = URL(string: url) {
//                if let data = try? Data(contentsOf: photoUrl) {
//                    return UIImage(data: data)
//                }
//            }
//            return nil
//        }
    }
}

struct GetTask: Codable {
    let shipment_id: Int
}

struct GetTaskResponse: Codable {
    let message: String
    let data: ResponseData?
    
    struct ResponseData: Codable {
        let good_id: Int
        let good_name: String
        let weight: Float
        let price: Int
        let photo_url: String?
        let start_station_name: String
        let des_station_name: String
    }
}

struct MyTask: Codable {
    let message: String?
    let id: Int?
    let status: String?
    let good_name: String?
    let weight: Float?
    let price: Int?
    let start_station_name: String?
    let des_station_name: String?
    let photo_url: String?
    
//    var image: UIImage? {
//        if let url = photo_url, let photoUrl = URL(string: url) {
//            if let data = try? Data(contentsOf: photoUrl) {
//                return UIImage(data: data)
//            }
//        }
//        return nil
//    }
}

struct CheckIn: Codable {
    let start_station_name: String
}

struct CheckInResponse: Codable {
    let message: String
}

struct CheckOut: Codable {
    let des_station_name: String
}

struct CheckOutResponse: Codable {
    let message: String
}

struct CancelTask: Codable {
    let shipment_id: Int
}

struct CancelTaskResponse: Codable {
    let message: String
}

struct RunnerHistoryResponse: Codable {
    let message: String
    let data: [RunnerHistoryData]?
    
    struct RunnerHistoryData: Codable {
        let good_name: String
        let start_station_name: String
        let des_station_name: String
        let distance: Int
        let weight: Float
        let price: Int
    }
}

struct RunnerMedalResponse: Codable {
    let message: String
    let data: RunnerMedalData
    
    struct RunnerMedalData: Codable {
        let distance: Int
        let badge_id: Int
        let badge_name: String
    }
}

class RunnerData {
    // MARK: - Get All Tasks
    func getAllTasks(completion: @escaping (TaskList) -> Void) {

        let url = URL(string: "\(urlAPI)/api/preparedTasks")!

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
                (200...299).contains(response.statusCode) else {
                    print ("server error")
                    return
            }

            guard let data = data else { return }

            do {
                let getStations = try JSONDecoder().decode(TaskList.self, from: data)
                completion(getStations)

            } catch let jsonErr {
                print("Error serialization json: \(jsonErr)")
            }
        }

        task.resume()
    }
    
    func confirmTask(shipmentId: Int, completion: @escaping (GetTaskResponse) -> Void) {
        
        let getTask = GetTask(shipment_id: shipmentId)
        
        guard let uploadData = try? JSONEncoder().encode(getTask) else {
            return
        }
        
        let url = URL(string: "\(urlAPI)/api/tasks")!
        
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
                (200...410).contains(response.statusCode) else {
                    print ("server error")
                    return
            }
            
            
            guard let data = data else { return }

            do {
                let getTaskResponse = try JSONDecoder().decode(GetTaskResponse.self, from: data)
                completion(getTaskResponse)

            } catch let jsonErr {
                print("Error serialization json: \(jsonErr)")
            }
            
        }
        
        task.resume()
    }
    
    func getTask(completion: @escaping (MyTask) -> Void) {

        let url = URL(string: "\(urlAPI)/api/myTask")!

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
                (200...410).contains(response.statusCode) else {
                    print ("server error")
                    return
            }

            guard let data = data else { return }

            do {
                let myTask = try JSONDecoder().decode(MyTask.self, from: data)
                completion(myTask)

            } catch let jsonErr {
                print("Error serialization json: \(jsonErr)")
            }
        }

        task.resume()
    }
    
    func checkIn(startStation: String, completion: @escaping (CheckInResponse) -> Void) {
        
        let getStartStation = CheckIn(start_station_name: startStation)
        
        guard let uploadData = try? JSONEncoder().encode(getStartStation) else {
            return
        }
        
        let url = URL(string: "\(urlAPI)/api/checkin")!
        
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
                (200...410).contains(response.statusCode) else {
                    print ("server error")
                    return
            }
            
            
            guard let data = data else { return }

            do {
                let getCheckInResponse = try JSONDecoder().decode(CheckInResponse.self, from: data)
                completion(getCheckInResponse)

            } catch let jsonErr {
                print("Error serialization json: \(jsonErr)")
            }
            
        }
        
        task.resume()
    }
    
    func checkOut(destinationStation: String, completion: @escaping (CheckOutResponse) -> Void) {
        
        let getDestinationStation = CheckOut(des_station_name: destinationStation)
        
        guard let uploadData = try? JSONEncoder().encode(getDestinationStation) else {
            return
        }
        
        let url = URL(string: "\(urlAPI)/api/checkout")!
        
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
                (200...410).contains(response.statusCode) else {
                    print ("server error")
                    return
            }
            
            
            guard let data = data else { return }

            do {
                let getCheckOutResponse = try JSONDecoder().decode(CheckOutResponse.self, from: data)
                completion(getCheckOutResponse)

            } catch let jsonErr {
                print("Error serialization json: \(jsonErr)")
            }
            
        }
        
        task.resume()
    }
    

    func cancelTask(shipmentId: Int, completion: @escaping (CancelTaskResponse) -> Void) {
        
        let cancelTask = CancelTask(shipment_id: shipmentId)
        
        guard let uploadData = try? JSONEncoder().encode(cancelTask) else {
            return
        }
        
        let url = URL(string: "\(urlAPI)/api/statusCancel")!
        
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
                (200...410).contains(response.statusCode) else {
                    print ("server error")
                    return
            }
            
            
            guard let data = data else { return }

            do {
                let cancelTaskResponse = try JSONDecoder().decode(CancelTaskResponse.self, from: data)
                completion(cancelTaskResponse)

            } catch let jsonErr {
                print("Error serialization json: \(jsonErr)")
            }
            
        }
        
        task.resume()
    }
    
    func runnerHistory(completion: @escaping (RunnerHistoryResponse) -> Void) {
        
        let url = URL(string: "\(urlAPI)/api/runnerHistory")!

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
                (200...410).contains(response.statusCode) else {
                    print ("server error")
                    return
            }

            guard let data = data else { return }

            do {
                let runnerHistory = try JSONDecoder().decode(RunnerHistoryResponse.self, from: data)
                completion(runnerHistory)

            } catch let jsonErr {
                print("Error serialization json: \(jsonErr)")
            }
        }

        task.resume()
    }
    
    func runnerMedal(completion: @escaping (RunnerMedalResponse) -> Void) {
        
        let url = URL(string: "\(urlAPI)/api/medalStatus")!

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
                (200...410).contains(response.statusCode) else {
                    print ("server error")
                    return
            }

            guard let data = data else { return }

            self.parsingJSON(data: data) { (decode: RunnerMedalResponse?, jsonErr) in
                guard let decode = decode else { return }
                completion(decode)
            }
        }

        task.resume()
    }
    
    private func parsingJSON<T: Codable>(data: Data, completion: @escaping (T?, _ error: String?) -> ()) {
        do {
            let json = try JSONDecoder().decode(T.self, from: data)
            completion(json, nil)

        } catch let jsonErr {
            print("Error serialization json: \(jsonErr)")
            completion(nil, jsonErr as? String)
        }
    }
    
}
