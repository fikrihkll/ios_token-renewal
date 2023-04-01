//
//  NetworkManager.swift
//  RefreshTokenRenewal
//
//  Created by Fikri Haikal on 28/03/23.
//

import Foundation
import Alamofire

private let API_BASE_URL = "https://api.fikrihkl.me/api"

actor NetworkManager: GlobalActor {
    static let shared = NetworkManager()
    let session: Session
    private init() {
        let tokenProvider = TokenProvider()
        let interceptor = AccessTokenInterceptor(tokenProvider: tokenProvider)
        
        let configuration = URLSessionConfiguration.af.default
        session = Session(configuration: configuration, interceptor: interceptor)
    }

    private let maxWaitTime = 15.0
    var commonHeaders: HTTPHeaders = [
        "user_id": "123",
        "token": "xxx-xx"
    ]

    func get(path: String, parameters: Parameters?) async throws -> Data {
       // You must resume the continuation exactly once
        return try await withCheckedThrowingContinuation { continuation in
            session.request(
                API_BASE_URL + path,
                parameters: parameters,
                headers: commonHeaders,
                requestModifier: { $0.timeoutInterval = self.maxWaitTime }
            )
            .responseData { response in
                switch(response.result) {
                case let .success(data):
                    continuation.resume(returning: data)
                case let .failure(error):
                    continuation.resume(throwing: self.handleError(error: error))
                }
            }
        }
    }
    
    func post(path: String, parameters: Parameters?) async throws -> Data {
       // You must resume the continuation exactly once
        return try await withCheckedThrowingContinuation { continuation in
            session.request(
                API_BASE_URL + path,
                method: .post, parameters: parameters,
                headers: commonHeaders,
                requestModifier: { $0.timeoutInterval = self.maxWaitTime }
            )
            .responseData { response in
                switch(response.result) {
                case let .success(data):
                    continuation.resume(returning: data)
                case let .failure(error):
                    continuation.resume(throwing: self.handleError(error: error))
                }
            }
        }
    }

    private func handleError(error: AFError) -> Error {
        if let underlyingError = error.underlyingError {
            let nserror = underlyingError as NSError
            let code = nserror.code
            if code == NSURLErrorNotConnectedToInternet ||
                code == NSURLErrorTimedOut ||
                code == NSURLErrorInternationalRoamingOff ||
                code == NSURLErrorDataNotAllowed ||
                code == NSURLErrorCannotFindHost ||
                code == NSURLErrorCannotConnectToHost ||
                code == NSURLErrorNetworkConnectionLost
            {
                var userInfo = nserror.userInfo
                userInfo[NSLocalizedDescriptionKey] = "Unable to connect to the server"
                let currentError = NSError(
                    domain: nserror.domain,
                    code: code,
                    userInfo: userInfo
                )
                return currentError
            }
        }
        return error
    }
}
