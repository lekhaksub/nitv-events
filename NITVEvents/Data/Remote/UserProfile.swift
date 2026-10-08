//
//  UserProfile.swift
//  NITVEvents
//
//  Created by Shubham Lekhak on 08/10/2026.
//


import Foundation

class UserProfile {
    
    private let TOKEN = "TOKEN"
    
    func saveUserProfile(model: LoginData){
        
        let token = model.token ?? ""
        
        UserDefaults.standard.set(token, forKey: TOKEN)
    }
    
    
    func getToken() -> String?{
        if let data = UserDefaults.standard.object(forKey: TOKEN) as? String{
            return data
        }
        return nil
    }
    
    func deleteUserProfile(){
        UserDefaults.standard.removeObject(forKey: TOKEN)
    }
    
    
}
