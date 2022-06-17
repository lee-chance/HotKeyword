//
//  ServiceProvider.swift
//  HotKeyword
//
//  Created by 이창수 on 2022/05/17.
//

import Foundation
import Combine

enum NetworkError: Error {
    case connectionError(Error)
    case serverError(statusCode: Int?)
    case noDataReceived
    case decodingError(DecodingError)
    case unknowError(Error)
}

final class ServiceProvider<S: Service> {
    let session = URLSession.shared
    
    init() { }
    
    func get<T: Decodable>(service: S, decodeType: T.Type, callback: @escaping (Result<T, Error>) -> ()) {
        session.dataTask(with: service.urlRequest) { data, response, error in
            // 1. Network Error Handling
            guard error == nil else {
                callback(.failure(NetworkError.connectionError(error!)))
                return
            }
            
            // 2. Server Error Handling
            let httpURLResponse = response as? HTTPURLResponse
            let statusCode = httpURLResponse?.statusCode
            #if DEBUG
            if let url = httpURLResponse?.url {
                Logger.debug("Request URL: \(url)")
            }
            #endif
            
            guard
                let code = statusCode,
                (200 ..< 300) ~= code
            else {
                callback(.failure(NetworkError.serverError(statusCode: statusCode)))
                return
            }
            
            // 3. No Data Error
            guard let data = data else {
                callback(.failure(NetworkError.noDataReceived))
                return
            }
            
            do {
                // 4. Decoding Data
                let decoded = try JSONDecoder().decode(decodeType, from: data)
                callback(.success(decoded))
            } catch {
                // 5. Decoding Error Handling
                guard let decodingError = error as? DecodingError else {
                    callback(.failure(NetworkError.unknowError(error)))
                    return
                }
                
                callback(.failure(NetworkError.decodingError(decodingError)))
            }
        }
        .resume()
    }
    
    func get<T: Decodable>(service: S, decodeType: T.Type) -> AnyPublisher<T, Error> {
        session.dataTaskPublisher(for: service.urlRequest)
            .tryMap { data, response in
                let httpURLResponse = response as? HTTPURLResponse
                let statusCode = httpURLResponse?.statusCode
                #if DEBUG
                if let url = httpURLResponse?.url {
                    Logger.debug("Request URL: \(url)")
                }
                #endif
                
                guard
                    let code = statusCode,
                    (200 ..< 300) ~= code
                else {
                    throw NetworkError.serverError(statusCode: statusCode)
                }
                
                return data
            }
            .mapError { error in
                NetworkError.connectionError(error)
            }
            .decode(type: decodeType, decoder: JSONDecoder())
            .mapError { error in
                if let decodingError = error as? DecodingError {
                    return NetworkError.decodingError(decodingError)
                } else {
                    return NetworkError.unknowError(error)
                }
            }
            .eraseToAnyPublisher()
    }
    
    @available(iOS 15.0, *)
    func get<T: Decodable>(service: S, decodeType: T.Type) async throws -> T {
        let result: (data: Data, response: URLResponse) = try await session.data(for: service.urlRequest)
        
        let httpURLResponse = result.response as? HTTPURLResponse
        let statusCode = httpURLResponse?.statusCode
        #if DEBUG
        if let url = httpURLResponse?.url {
            Logger.debug("Request URL: \(url)")
        }
        #endif
        
        guard
            let code = statusCode,
            (200 ..< 300) ~= code
        else {
            throw NetworkError.serverError(statusCode: statusCode)
        }
        
        return try JSONDecoder().decode(decodeType, from: result.data)
    }
    
//    func load(service: T, completion: @escaping (Result<Data>) -> Void) {
//        call(service.urlRequest, completion: completion)
//    }
    
//    func load<U>(service: T, decodeType: U.Type, completion: @escaping (Result<U>) -> Void) where U: Decodable {
//        call(service.urlRequest) { result in
//            switch result {
//            case .success(let data):
//                do {
//                    let response = try JSONDecoder().decode(decodeType, from: data)
//                    completion(.success(response))
//                } catch {
//                    completion(.failure(error))
//                }
//            case .failure(let error):
//                completion(.failure(error))
//            case .empty:
//                completion(.empty)
//            }
//        }
//    }
}
