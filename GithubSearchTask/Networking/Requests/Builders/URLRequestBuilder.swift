import Foundation
import Alamofire

struct AuthCredentials {
    let username: String
    let password: String
}

protocol URLRequestBuilder: URLRequestConvertible, APIRequestHandler {

    var mainURL: URL { get }
    var requestURL: URL { get }

    var headers: HTTPHeaders? { get }

    var path: String { get }

    // MARK: - Parameters
    var parameters: Parameters? { get }

    // MARK: - Methods
    var method: HTTPMethod { get }

    var encoding: ParameterEncoding { get }

    var urlRequest: URLRequest { get }

    var mockedResponses: Data? { get }

    var isMultipartRequest: Bool { get }

    var overridedBaseUrl: String? { get }

}


extension URLRequestBuilder {

    var encoding: ParameterEncoding {
        switch method {
        case .get, .delete:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }

    var mainURL: URL  {
        return URL(string: Configuration.get(key: Constants.ModeKeys.serverURL) as! String)!
    }

    var requestURL: URL {
        return mainURL.appendingPathComponent(path)
    }

    var defaultParams: Parameters {
        let param = Parameters()
        /**
         If we have some defoult parameters just add it
         */
       // param["app_lang"] = AppEnvironement.currentLang ?? "en"
       // param["mobile_id"] = deviceId
        return param
    }

    var urlRequest: URLRequest {
        var request = URLRequest(url: requestURL)
        request.httpMethod = method.rawValue
        if let headersList = headers {
            headersList.forEach { request.addValue($0.value, forHTTPHeaderField: $0.name) }
        }
        return request
    }

    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        if !isMultipartRequest {
            return try encoding.encode(urlRequest, with: parameters)
        }

        return try encoding.encode(urlRequest, with: nil)
    }
}
