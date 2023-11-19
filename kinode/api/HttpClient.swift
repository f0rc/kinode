//
//  HttpClient.swift
//  movieapp
//
//  Created by mops on 10/30/23.
//

import Foundation

enum HttpMethod {
    
    case get([URLQueryItem])
    case post(Data?)
    case delete
    
    var name: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .delete:
            return "DELETE"
        }
    }
}

struct Resource<T: Codable> {
    let url: URL
    var headers: [String: String] = [:]
    var method: HttpMethod = .get([])
}

class StoreHTTPClient {
    
    func load<T: Codable>(_ resource: Resource<T>) async throws -> T {
        
        var request = URLRequest(url: resource.url)
        request.allHTTPHeaderFields = resource.headers
        request.httpMethod = resource.method.name
        
        switch resource.method {
        case .get(let queryItems):
            var components = URLComponents(url: resource.url, resolvingAgainstBaseURL: true)
            components?.queryItems = queryItems
            guard let url = components?.url else {
                throw NetworkError.badUrl
            }
            request.url = url
        case .post(let data):
            request.httpBody = data
            
        default:
            break
        }
        
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = ["Content-Type": "application/json"]
        
        let session = URLSession(configuration: configuration)
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 || httpResponse.statusCode == 201
        else {
            print("[httpClient load] http status code is not 200 or 201")
//            print(response)
//            print(data)
            throw NetworkError.invalidResponse
        }
        
        guard let result = try? JSONDecoder().decode(T.self, from: data) else {
            print("[httpClient load] after success req decode failed")
            throw NetworkError.decodingError
        }
        
        return result
        
    }
    
}


enum NetworkError: Error {
    case badUrl
    case invalidResponse
    case decodingError
    case invalidServerResponse
    case invalidURL
}


extension URL {
    
    static var development: URL {
        URL(string: "http://localhost:3000")!
    }
    
    static var production: URL {
        URL(string: "http://localhost:3000")!
    }
    
    static var `default`: URL {
#if DEBUG
        return development
#else
        return production
#endif
    }
    
    static var createUser: URL {
        return URL(string: "/api/createuser/", relativeTo: Self.default)!
    }
    
    static var login: URL {
        URL(string: "/api/login", relativeTo: Self.default)!
    }
    
    
    static var logout: URL {
        return URL(string: "/api/logout", relativeTo: Self.default)!
    }
    
    static var verifySession: URL {
        return URL(string: "/api/verifytoken", relativeTo: Self.default)!
    }
    
    
    static var search: URL {
        return URL(string: "/api/search", relativeTo: Self.default)!
    }
    
    static var review: URL {
        return URL(string: "/api/createReview", relativeTo: Self.default)!
    }
    
    static var getReviews: URL {
        return URL(string: "/api/getReviews", relativeTo: Self.default)!
    }
    
    
    static var updateProfile: URL {
        return URL(string: "/api/user/profile/updateProfile", relativeTo: Self.default)!
    }
    
    static var getProfile: URL {
        return URL(string: "/api/user/profile/getProfile", relativeTo: Self.default)!
    }
    
}
