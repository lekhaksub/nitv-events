//
//  APIManager.swift
//  NITVEvents
//
//  Created by Shubham Lekhak on 08/10/2026.
//

import Foundation
import Alamofire
import UIKit

// MARK: - RefreshTokenModel
struct RefreshTokenModel: Codable {
    let status: Bool?
    let data: DataClass?
    
    // MARK: - DataClass
    struct DataClass: Codable {
        let token: String?

        enum CodingKeys: String, CodingKey {
            case token = "access_token"
        }
    }
}

class APIManager{
    static let shared: APIManager = {
        return APIManager()
    }()
    var request: Alamofire.Request?
    let retryLimit = 2
    
    static func getHeaders() -> HTTPHeaders{
        if let token = UserProfile().getToken(){
            print("Token: \(token)")
            return ["Authorization": "Bearer \(token)", "User-Agent": "ios"] as HTTPHeaders
        }
        else{
            return ["Content-Type": "application/x-www-form-urlencoded", "User-Agent": "ios"] as HTTPHeaders
        }
    }
    
    func request<T: Codable>(ofType type: T.Type, url: URLConvertible, method: HTTPMethod = .get, parameters: [String: Any] = [:], headers: HTTPHeaders? = getHeaders(), language: String? = nil, interceptor: RequestInterceptor? = nil, completion: @escaping (Bool, String, T?, Int)-> ()){
        
        AF.request(url, method: method, parameters: parameters, encoding: URLEncoding.default, headers: headers)
            .validate()
            .responseData { (response) in
                print("description: \(response.description)")
                print("parameters: \(parameters)")
                print("debugDescription: \(response.debugDescription)")
                switch response.result{
                case .success(let model):
                    print("model: \(model)")
                    print("urlString:: \(url)")
                    if let statusCode = response.response?.statusCode{
                        print("status code \(statusCode)")
                        if statusCode == 200 || statusCode == 204 || statusCode == 201{
                            print(response.data as Any)
                            if let modelData = response.data{
                                do{
                                    let modelObject = try JSONDecoder().decode(T.self, from: modelData)
                                    completion(true,"", modelObject, statusCode)
                                }catch (let ex){
                                    print(" error \(ex)")
                                    completion(false, NSLocalizedString("Something went wrong", comment: ""), nil, statusCode)
                                }
                            }
                            else if statusCode == 204{
                                completion(true, "", nil, statusCode)
                            }
                            else{
                                completion(false, NSLocalizedString("Something went wrong", comment: ""), nil, statusCode)
                            }
                        }else{
                            completion(false, NSLocalizedString("Something went wrong", comment: ""), nil, statusCode)
                        }
                    }else{
                        completion(false, NSLocalizedString("Something went wrong", comment: ""), nil, response.response?.statusCode ?? 0)
                    }
                case .failure(let error):
                    print("status code: \(String(describing: response.response?.statusCode))")
//                    if let modelData = response.data{
//                        do{
//                            let modelObject = try JSONDecoder().decode(ErrorModel.self, from: modelData)
//                            completion(false, modelObject.message ?? (modelObject.error ?? ""), nil, response.response?.statusCode ?? 0)
//                        }catch (let ex){
//                            print(" error \(ex)")
//                            completion(false, NSLocalizedString("Something went wrong", comment: ""), nil, response.response?.statusCode ?? 0)
//                        }
//                    }else{
                        completion(false, error.localizedDescription, nil, response.response?.statusCode ?? 0)
//                    }

                }
            }
    }


}


private extension UIApplication {
    static var keyWindow: UIWindow? {
        if #available(iOS 13.0, *) {
         return UIApplication.shared.windows.filter {$0.isKeyWindow}.first
         } else {
            return UIApplication.shared.delegate?.window ?? nil
         }
    }
}

private extension UIWindow {
    
    static var currentController: UIViewController? {
        return UIApplication.keyWindow?.currentController
    }
    
    var currentController: UIViewController? {
        if let vc = self.rootViewController {
            return topViewController(controller: vc)
        }
        return nil
    }
    
    func topViewController(controller: UIViewController? = UIApplication.keyWindow?.rootViewController) -> UIViewController? {
        if let nc = controller as? UINavigationController {
            if nc.viewControllers.count > 0 {
                return topViewController(controller: nc.viewControllers.last!)
            } else {
                return nc
            }
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
