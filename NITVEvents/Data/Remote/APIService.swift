import Foundation

enum APIError: LocalizedError {
    case http(code: Int, message: String?)
    case network
    case decoding

    var errorDescription: String? {
        switch self {
        case .http(let code, let message):
            if let message, !message.isEmpty { return message }
            return "Request failed (\(code))"
        case .network: return "No internet connection. Please try again."
        case .decoding: return "Unexpected response from the server."
        }
    }
}

func errorMessage(_ error: Error) -> String {
    (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
}

protocol APIService {
    /// POST {baseURL}auth/login   body: {"email": "...", "password": "..."}
    func login(_ body: LoginRequest) async throws -> LoginResponse
    /// GET {baseURL}tickets/search?q=<name | ticketId | phone>
    func searchTickets(query: String) async throws -> TicketSearchResponse
}

final class RemoteAPIService: APIService {
    private let baseURL: URL
    private let session: URLSession
    private let tokenStorage: TokenStorage

    init(baseURL: URL, tokenStorage: TokenStorage, session: URLSession = .shared) {
        self.baseURL = baseURL
        self.tokenStorage = tokenStorage
        self.session = session
    }

    func login(_ body: LoginRequest) async throws -> LoginResponse {
        var request = URLRequest(url: baseURL.appendingPathComponent("api/v1/login"))
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(body)
        return try await send(request)
    }

    func searchTickets(query: String) async throws -> TicketSearchResponse {
        var components = URLComponents(url: baseURL.appendingPathComponent("api/v1/tickets/search"), resolvingAgainstBaseURL: false)!
        components.queryItems = [URLQueryItem(name: "q", value: query)]
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        return try await send(request)
    }

    private func send<T: Decodable>(_ original: URLRequest) async throws -> T {
        var request = original
        request.timeoutInterval = 30
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        if let token = tokenStorage.getToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.data(for: request)
        } catch let error as URLError where error.code == .cancelled {
            throw CancellationError()
        } catch {
            throw APIError.network
        }

        guard let http = response as? HTTPURLResponse else { throw APIError.network }
        guard (200..<300).contains(http.statusCode) else {
//            let message = try? JSONDecoder().decode(ErrorDTO.self, from: data).error
            throw APIError.http(code: http.statusCode, message: "Error")
        }
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw APIError.decoding
        }
    }
}
