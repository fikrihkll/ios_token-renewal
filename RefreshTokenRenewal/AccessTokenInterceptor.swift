//
//  AccessTokenInterceptor.swift
//  RefreshTokenRenewal
//
//  Created by Fikri Haikal on 28/03/23.
//

import Foundation
import Alamofire

class AccessTokenInterceptor: RequestInterceptor {
    
    private let tokenProvider: TokenProvider
    
    init(tokenProvider: TokenProvider) {
        self.tokenProvider = tokenProvider
    }
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        if let token = tokenProvider.accessToken {
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        print("success")
        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) async {
        print("errors")
        guard let response = request.task?.response as? HTTPURLResponse,
              response.statusCode == 401 else {
            completion(.doNotRetryWithError(error))
            return
        }
        completion(.doNotRetryWithError(error))
//        await tokenProvider.refreshToken(completion: { success in
//            if success {
//                completion(.retry)
//            } else {
//                completion(.doNotRetry)
//            }
//        })
    }
}
