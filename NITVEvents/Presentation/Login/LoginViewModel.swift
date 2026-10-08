import Foundation
import Combine

struct LoginState {
    var isLoading = false
    var error: String?
}

@MainActor
final class LoginViewModel {
    var model: LoginModel?
    
    public func postLogin(params: [String: Any], completion: @escaping (Bool, String, Int) -> () ){
        
        let url = "https://dev-tickets.miravostream.com/api/v1/login"
        
        APIManager.shared.request(ofType: LoginModel.self, url: URL(string: url)!, method: .post, parameters: params){ (status, errorMessage, model, statusCode) in
            if status{
                self.model = model
                if let mod = model?.data{
                        UserProfile().saveUserProfile(model: mod)
                    
                }
                completion(true, "", statusCode)
            }else{
                completion(false, errorMessage, statusCode)
            }
        }
    }
}
