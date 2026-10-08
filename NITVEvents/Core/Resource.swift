import Foundation

enum Resource<T> {
    case success(T)
    case failure(String)
}

extension String {
    var trimmed: String { trimmingCharacters(in: .whitespacesAndNewlines) }
}
