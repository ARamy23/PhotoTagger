//
//  MoyaManager.swift
//  camelan
//
//  Created by Ahmed Ramy on 1/30/20.
//  Copyright © 2020 Camelan . All rights reserved.
//

import Moya
import Mapper
import Moya_ModelMapper
import Promises
import Alamofire
import FirebaseAuth

class CustomServerTrustManager : ServerTrustManager {
    
    override func serverTrustEvaluator(forHost host: String) throws -> ServerTrustEvaluating? {
        return DisabledEvaluator()
    }

    public init() {
        super.init(evaluators: [:])
    }
}

class MoyaManager: NetworkProtocol {
    static let session = Session(
        configuration: .default,
        serverTrustManager: CustomServerTrustManager())
    
    func renewToken(onRenew: @escaping (() -> Void)) {
        Auth.auth().currentUser?.getIDToken(completion: { (token, error) in
            if let error = error {
                print(error)
                onRenew()
            }
            KeyChain.userToken = token
            onRenew()
        })
    }
    
    private func handleErrorResponse(_ response: Response) throws {
        if let backendIssueError = try? response.map(BackendIssueError.self) {
            let error = NetworkError.errorWithMessage(backendIssueError.message)
            LoggersManager.logError(error: error)
            throw error
        } else if let errorResponse = try? response.map(APIErrorResponse.self) {
            let error = errorResponse.errors.first
            let mappedError = NetworkError.errorWithMessage(errorResponse.errors.first?.message ?? "Something went wrong") // since backend returns array of errors, we take the first one and display it to the user
            LoggersManager.logError(tag: .networking, error: mappedError)
            throw error?.didTokenExpire == true ? NetworkError.tokenExpired : mappedError
        }
    }
    
    func call<U: TargetType, T: Codable>(api: U, model: T.Type) -> Promise<T> {
        return Promise<T> { fullfil, reject in
            let provider = MoyaProvider<U>(session: Self.session)
            provider.request(api) { (result) in
                switch result {
                case .success(let response):
                    do {
                        try self.handleErrorResponse(response)
                        let model = try response.map(T.self)
                        fullfil(model)
                    } catch let error as NetworkError {
                        switch error {
                        case .tokenExpired:
                            self.renewToken { [weak self] in
                                guard let self = self else { return }
                                self.call(api: api, model: model) { (result) in
                                    switch result {
                                    case let .success(model):
                                        fullfil(model)
                                    case let .failure(error):
                                        reject(error)
                                    }
                                }
                            }
                        default:
                            reject(error)
                        }
                    } catch let error {
                        let parsingError = error as? MoyaError
                        if parsingError != nil {
                            LoggersManager.logError(tag: .networking, message: parsingError.debugDescription)
                        }
                        LoggersManager.logError(tag: .networking, error: error)
                        LoggersManager.logError(tag: .networking, message: error.localizedDescription)
                        reject(error)
                    }
                case .failure(let error):
                    LoggersManager.logError(tag: .networking, error: error)
                    LoggersManager.logError(tag: .networking, message: error.localizedDescription)
                    reject(error)
                }
            }
        }
    }
    
    func call<T: Codable, U: TargetType>(api: U, model: T.Type, _ onFetch: @escaping (Swift.Result<T, Error>) -> Void) {
        let provider = MoyaProvider<U>(session: Self.session)
        provider.request(api) { (result) in
            switch result {
            case .success(let response):
                do {
                    try self.handleErrorResponse(response)
                    let data = try response.map(model)
                    onFetch(.success(data))
                } catch let error as NetworkError {
                    switch error {
                    case .tokenExpired:
                        self.renewToken {
                            self.call(api: api, model: model, onFetch)
                        }
                    default:
                        onFetch(.failure(error))
                    }
                } catch let error {
                    let parsingError = error as? MoyaError
                    if parsingError != nil {
                        LoggersManager.logError(tag: .networking, message: parsingError.debugDescription)
                    }
                    LoggersManager.logError(tag: .networking, error: error)
                    LoggersManager.logError(tag: .networking, message: error.localizedDescription)
                    onFetch(.failure(error))
                }
            case .failure(let error):
                LoggersManager.logError(tag: .networking, error: error)
                LoggersManager.logError(tag: .networking, message: error.localizedDescription)
                onFetch(.failure(error))
            }
        }
    }
    
    func call<T: Mappable, U: TargetType>(api: U, model: T.Type, _ onFetch: @escaping (Swift.Result<T, Error>) -> Void) {
        let provider = MoyaProvider<U>(session: Self.session)
        provider.request(api) { (result) in
            switch result {
            case .success(let response):
                do {
                    try self.handleErrorResponse(response)
                    let data = try response.map(to: model)
                    onFetch(.success(data))
                } catch let error as NetworkError {
                    switch error {
                    case .tokenExpired:
                        self.renewToken {
                            self.call(api: api, model: model, onFetch)
                        }
                    default:
                        onFetch(.failure(error))
                    }
                } catch let error {
                    let parsingError = error as? MoyaError
                    if parsingError != nil {
                        LoggersManager.logError(tag: .networking, message: parsingError.debugDescription)
                    }
                    LoggersManager.logError(tag: .networking, error: error)
                    LoggersManager.logError(tag: .networking, message: error.localizedDescription)
                    onFetch(.failure(error))
                }
            case .failure(let error):
                LoggersManager.logError(tag: .networking, error: error)
                LoggersManager.logError(tag: .networking, message: error.localizedDescription)
                onFetch(.failure(error))
            }
        }
    }
    
    func call<T: Mappable, U: TargetType>(api: U, model: [T].Type, _ onFetch: @escaping (Swift.Result<[T], Error>) -> Void) {
        let provider = MoyaProvider<U>(session: Self.session)
        provider.request(api) { (result) in
            switch result {
            case .success(let response):
                do {
                    try self.handleErrorResponse(response)
                    let data = try response.map(to: model)
                    onFetch(.success(data))
                } catch let error as NetworkError {
                    switch error {
                    case .tokenExpired:
                        self.renewToken {
                            self.call(api: api, model: model, onFetch)
                        }
                    default:
                        onFetch(.failure(error))
                    }
                } catch let error {
                    let parsingError = error as? MoyaError
                    if parsingError != nil {
                        LoggersManager.logError(tag: .networking, message: parsingError.debugDescription)
                    }
                    LoggersManager.logError(tag: .networking, error: error)
                    onFetch(.failure(error))
                }
            case .failure(let error):
                LoggersManager.logError(tag: .networking, error: error)
                LoggersManager.logError(tag: .networking, message: error.localizedDescription)
                onFetch(.failure(error))
            }
        }
    }
    
    func callEmptyResponse<U>(api: U, _ onFetch: @escaping (Swift.Result<Void, Error>) -> Void) where U : TargetType {
        let provider = MoyaProvider<U>(session: Self.session)
        provider.request(api) { (result) in
            switch result {
            case .success(let response):
                do {
                    try self.handleErrorResponse(response)
                    onFetch(.success(()))
                } catch let error as NetworkError {
                    switch error {
                    case .tokenExpired:
                        self.renewToken {
                            self.callEmptyResponse(api: api, onFetch)
                        }
                    default:
                        onFetch(.failure(error))
                    }
                } catch let error {
                    LoggersManager.logError(tag: .networking, message: error.localizedDescription)
                    onFetch(.failure(error))
                }
            case .failure(let error):
                LoggersManager.logError(tag: .networking, error: error)
                LoggersManager.logError(tag: .networking, message: error.localizedDescription)
                onFetch(.failure(error))
            }
        }
    }
    
    func call<U: TargetType>(api: U, _ onFetch: @escaping (Swift.Result<Response, Error>) -> Void) {
        let provider = MoyaProvider<U>(session: Self.session)
        provider.request(api) { result in
            switch result {
            case .success(let response):
                do {
                    try self.handleErrorResponse(response)
                    onFetch(.success(response))
                } catch let error as NetworkError {
                    switch error {
                    case .tokenExpired:
                        self.renewToken {
                            self.call(api: api, onFetch)
                        }
                    default:
                        onFetch(.failure(error))
                    }
                } catch let error {
                    LoggersManager.logError(tag: .networking, error: error)
                    LoggersManager.logError(tag: .networking, message: error.localizedDescription)
                    onFetch(.failure(error))
                }
            case .failure(let error):
                LoggersManager.logError(tag: .networking, error: error)
                LoggersManager.logError(tag: .networking, message: error.localizedDescription)
                onFetch(.failure(error))
            }
        }
    }
}

struct APIErrorResponse: Decodable {
    let errors: [ErrorResponse]
}

struct BackendIssueError: Decodable {
    let message: String
    let statusCode: Int
}

struct ErrorResponse: Decodable {
    let message: String
    let code: String
    
    var didTokenExpire: Bool {
        return (code) == "USER_NOT_AUTHORIZED"
    }
}
