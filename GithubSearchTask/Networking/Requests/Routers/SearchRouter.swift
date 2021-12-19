import Foundation
import Alamofire


// MARK: - URL Requests

enum SearchRouter: URLRequestBuilder {

    case searchRepositories(request: SearchRepositoriesRequest)

    // MARK: Override base url if required

    internal var overridedBaseUrl: String? {
        return nil
    }

    // MARK: Path

    internal var path: String {
        switch self {
        case .searchRepositories:
            return "search/repositories"
        }
    }

    // MARK: Parameters

    internal var parameters: Parameters? {
        var params = defaultParams

        switch self {
        case .searchRepositories(let request):
            params["q"] = request.searchString
            params["page"] = request.page
            params["per_page"] = request.perPage
        }

        return params
    }

    // MARK: Header

    var headers: HTTPHeaders?  {
        return [
            "Accept": "application/json"]
    }

    // MARK: Methods

    internal var method: HTTPMethod {
        switch self {
        case .searchRepositories:
            return .get
        }
    }

    // MARK: Mock

    internal var mockedResponses: Data? {
        return nil
    }

    // MARK: Multipart/form-data request definition

    internal var isMultipartRequest: Bool {
        return false
    }
}
