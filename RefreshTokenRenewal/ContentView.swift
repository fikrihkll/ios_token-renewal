//
//  ContentView.swift
//  RefreshTokenRenewal
//
//  Created by Fikri Haikal on 27/03/23.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var presenter = ContentPresenter()
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            
            Text("Hello, world!")
            Spacer().frame(height: 30)
            
            Button(action: {
                presenter.getMessageOla(isUnauthorized: false)
                presenter.getMessageVoila(isUnauthorized: false)
            }) {
               Text("Hit Authorize")
            }
            Button(action: {
                presenter.getMessageOla(isUnauthorized: true)
                presenter.getMessageVoila(isUnauthorized: true)
            }) {
               Text("Hit Unauthorize")
            }
            
            Spacer().frame(height: 30)
            Text(getData(response: self.presenter.voilaResponse))
            Text(getData(response: self.presenter.olaResponse))
            Spacer().frame(height: 60)
            
            
        }
        .padding()
    }
    
    func getData(response: ResponseData) -> String {
        if (response.isSuccess) {
            let data: String = response.data?["message"] as? String ?? "-"
            return data
        } else {
            let data: String = response.message
            return data
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
