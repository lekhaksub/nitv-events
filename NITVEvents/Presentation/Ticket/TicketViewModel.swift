import Foundation
import Combine

//struct TicketState {
//    var query = ""
//    var isLoading = false
//    var results: [Ticket] = []
//    var searched = false
//    var error: String?
//}

@MainActor
final class TicketViewModel {
    var searchModel: TicketResponse?
    var searchList: [TicketData] = []
    
//    @Published private(set) var state = TicketState()
//
//    private let searchTickets: SearchTicketsUseCase
//    private var searchTask: Task<Void, Never>?
//
//
//    init(searchTickets: SearchTicketsUseCase) {
//        self.searchTickets = searchTickets
//    }
//
//    func onQueryChange(_ query: String) {
//        searchTask?.cancel()
//
//        guard !query.trimmed.isEmpty else {
//            state = TicketState(query: query)
//            return
//        }
//        state.query = query
//
//        searchTask = Task {
//            try? await Task.sleep(nanoseconds: 400_000_000)   // debounce while typing
//            if Task.isCancelled { return }
//            state.isLoading = true
//            state.error = nil
//
//            let result = await searchTickets(query: query)
//            if Task.isCancelled { return }
//
//            switch result {
//            case .success(let tickets):
//                state.isLoading = false
//                state.results = tickets
//                state.searched = true
//            case .failure(let message):
//                state.isLoading = false
//                state.results = []
//                state.searched = true
//                state.error = message
//            }
//        }
//    }
    
    
    public func fetchSearchList(searchText: String, completion: @escaping (Bool, String, Int) -> () ){
        let url = "https://dev-tickets.miravostream.com/api/v1/tickets/search"
        
        let params: [String: String] = ["search": searchText]
        
        APIManager.shared.request(ofType: TicketResponse.self, url: URL(string: url)!, method: .post, parameters: params){ (status, errorMessage, model, statusCode) in
            if status{
                self.searchModel = model
                self.searchList = model?.data ?? []
                completion(true, "", statusCode)
            }else{
                completion(false, errorMessage, statusCode)
            }
        }
    }
}
