//import Foundation
//
//final class TicketRepositoryImpl: TicketRepository {
//    private let api: APIService
//
//    init(api: APIService) {
//        self.api = api
//    }
//
//    func search(query: String) async -> Resource<[Ticket]> {
//        do {
//            let response = try await api.searchTickets(query: query)
//            return .success((response.data ?? []).map { $0.toDomain() })
//        } catch {
//            return .failure(errorMessage(error))
//        }
//    }
//}
//
//private extension TicketDTO {
//    func toDomain() -> Ticket {
//        let id = ticketId ?? ""
//        // Falls back to a URL built from baseURL if the API doesn't send "view_url"
//        let fallback = AppConfig.baseURL.appendingPathComponent("tickets/view/\(id)").absoluteString
//        return Ticket(
//            ticketId: id,
//            holderName: name ?? "",
//            phone: phone ?? "",
//            purchaseId: 0,
//            show: show ?? "",
//            status: status ?? "",
//            viewURL: (viewUrl?.isEmpty == false) ? viewUrl! : fallback
//        )
//        
//    }
//}
