//
//  EksiAPI.swift
//  eskiclient
//
//  Created by Onur Geneş on 9.10.2020.
//

import Foundation
import Combine
import Alamofire
import SwiftSoup

protocol EksiAPIProtocol: AnyObject {
    var baseURL: String { get set }
    func getHomePage() -> AnyPublisher<String, AFError>
}

final class EksiAPI: EksiAPIProtocol {
    var baseURL: String = "https://eksisozluk.com"
    
    func getHomePage() -> AnyPublisher<String, AFError> {
        fetchGetString("/basliklar/bugun/1")
    }
    
    func getDetails(link: String) -> AnyPublisher<String, AFError> {
        fetchGetString(link)
    }
}

extension EksiAPI {
    private func fetchGetDecodable<T: Decodable>(_ path: String) -> AnyPublisher<T, AFError> {
        AF.request(baseURL + path,
                   method: .get,
                   headers: HTTPHeaders())
            .publishDecodable(type: T.self)
            .value()
    }
    
    private func fetchGetString(_ path: String) -> AnyPublisher<String, AFError> {
        AF.request(baseURL + path,
                   method: .get,
                   headers: HTTPHeaders())
            .publishString()
            .value()
    }
    
    private func fetchPost<T: Decodable, U: Encodable>(path: String, params: U?) -> AnyPublisher<T, AFError> {
        AF.request(baseURL + path,
                   method: .post,
                   parameters: params,
                   encoder: JSONParameterEncoder.default,
                   headers: HTTPHeaders())
            .publishDecodable(type: T.self)
            .value()
    }
    
    private func fetch<T: Decodable, U: Encodable>(path: String, method: HTTPMethod, params: U?) -> AnyPublisher<T, AFError> {
        AF.request(path,
                   method: method,
                   parameters: params,
                   encoder: JSONParameterEncoder.default,
                   headers: HTTPHeaders())
            .validate()
            .publishDecodable(type: T.self)
            .value()
    }
}
