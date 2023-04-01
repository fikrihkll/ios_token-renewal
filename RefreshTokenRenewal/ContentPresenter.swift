//
//  ContentPresenter.swift
//  RefreshTokenRenewal
//
//  Created by Fikri Haikal on 28/03/23.
//

import Foundation

class ContentPresenter : ObservableObject {
    
    @MainActor @Published var voilaResponse: ResponseData = ResponseData(isSuccess: true, data: ["message": "-"], message: "")
    @MainActor @Published var olaResponse: ResponseData = ResponseData(isSuccess: true, data: ["message": "-"], message: "")
    
    init () {}
    
    func getMessageVoila(isUnauthorized: Bool) {
        Task.detached(operation: {
            let result = await NetworkAPI.getMessage(message: "Voilaa", isUnauthorized: isUnauthorized)
            await MainActor.run(body: {
                self.voilaResponse = result
            })
        })
    }
    
    func getMessageOla(isUnauthorized: Bool) {
        Task.detached(operation: {
            let result = await NetworkAPI.getMessage(message: "Olaa", isUnauthorized: isUnauthorized)
            await MainActor.run(body: {
                self.olaResponse = result
            })
        })
    }
    
}

struct ResponseData {
    
    let isSuccess: Bool
    let data: [String: Any]?
    let message: String
    
}
