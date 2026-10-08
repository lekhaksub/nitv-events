import Foundation

enum AppConfig {
    /// TODO: put your real backend here (should end with "/")
    static let baseURL = URL(string: "https://dev-tickets.miravostream.com/")!  // Dev API
//    static let baseURL = URL(string: "https://tickets.miravostream.com/")!  // Live API

    /// true  -> fake responses from MockAPIService (app runs without a backend)
    /// false -> real network calls to `baseURL`
    static let useMockAPI = false
}
