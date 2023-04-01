//
//  UserRepository.swift
//  RefreshTokenRenewal
//
//  Created by Fikri Haikal on 27/03/23.
//

import Alamofire
import Foundation

class NetworkAPI {
    static func getMessage(message: String, isUnauthorized: Bool) async -> ResponseData {
        do {
            let parameters: Parameters = [
                "is_unauthorized": isUnauthorized ? 1 : 0,
                "message": message
            ]
            let data = try await NetworkManager.shared.get(
                path: "/test/unauthorized", parameters: parameters
            )
            print("")
            print("Data: \(String(data: data, encoding: .utf8) ?? "")")
            let result: ResponseData = try self.parseData(data: data)
            return result
        } catch let error {
            print(error.localizedDescription)
            return ResponseData(isSuccess: false, data: nil, message: "Error fetching\n\(error.localizedDescription)")
        }
    }
    
    static func renewToken(token: String) async -> ResponseData {
        do {
            let parameters: Parameters = [
                "token": token,
            ]
            let data = try await NetworkManager.shared.post(
                path: "/test/renew-token", parameters: parameters
            )
            print("")
            print("Data: \(String(data: data, encoding: .utf8) ?? "")")
            let result: ResponseData = try self.parseData(data: data)
            return result
        } catch let error {
            print(error.localizedDescription)
            return ResponseData(isSuccess: false, data: nil, message: "Error fetching\n\(error.localizedDescription)")
        }
    }

    private static func parseData(data: Data) throws -> ResponseData {
        guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            throw NSError(
                domain: "NetworkAPIError",
                code: 3,
                userInfo: [NSLocalizedDescriptionKey: "Error parsing JSON response"]
            )
        }

        let message = json["message"] as? String ?? "no message"
        let isSuccess = json["status"] as? Bool ?? false
        let dataDict = json["data"] as? [String: Any]

        return ResponseData(isSuccess: isSuccess, data: dataDict, message: message)
    }

}
