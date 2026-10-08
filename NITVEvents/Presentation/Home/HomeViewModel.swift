//
//  HomeViewModel.swift
//  NITVEvents
//
//  Created by Shubham Lekhak on 08/10/2026.
//

import Foundation
import Combine


@MainActor
final class HomeViewModel {
    
    var model: ScennedTicketResponse?
    
    public func fetchScannedTicketData(params: [String: Any], completion: @escaping (Bool, String, Int) -> () ){
        
        let url = "https://dev-tickets.miravostream.com/api/v1/tickets/scan"
        
        APIManager.shared.request(ofType: ScennedTicketResponse.self, url: URL(string: url)!, method: .post, parameters: params){ (status, errorMessage, model, statusCode) in
            if status{
                self.model = model
                completion(true, "Success", statusCode)
            }else{
                completion(false, errorMessage, statusCode)
            }
        }
    }
}
