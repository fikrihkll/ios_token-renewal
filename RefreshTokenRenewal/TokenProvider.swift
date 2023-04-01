//
//  TokenProvider.swift
//  RefreshTokenRenewal
//
//  Created by Fikri Haikal on 28/03/23.
//

import Foundation
import Alamofire

class TokenProvider {
    
    var accessToken: String?
    private var refreshToken: String?
    private var isRefreshingToken = false
    
    init() {}
    
    func refreshToken(completion: @escaping (Bool) -> Void) async {
        guard let refreshToken = refreshToken else {
            completion(false)
            return
        }
        
        let parameters = [
            "grant_type": "refresh_token",
            "refresh_token": refreshToken,
        ]
        
        let result = await NetworkAPI.renewToken(token: "abc")
        
        if let data = result.data {
            self.accessToken = data["new_token"] as? String
            self.refreshToken = data["new_token"] as? String
            completion(true)
        } else {
            completion(false)
        }
    }
}

enum TokenProviderError: Error {
    case refreshTokenMissing
    case tokenRefreshFailed
}
