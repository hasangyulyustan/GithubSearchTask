import Foundation
import Alamofire

// MARK: - Types -

/// Response completion handler beautified.
typealias CallResponse<T> = ((ServerResponse<T>) -> Void)?

// MARK: - Protocols -

/// API protocol, The alamofire wrapper
protocol APIRequestHandler: HandleAlamoResponse {}

let session = Session(configuration: URLSessionConfiguration.af.default)

// MARK: - extension APIRequestHandler -
extension APIRequestHandler {

    private func uploadToServerWith<T: Decodable>(_ decoder: T.Type, data: [UploadData], request: URLRequestConvertible, parameters: Parameters?, progress: ((Progress) -> Void)?, completion: CallResponse<T>) {
        session.upload(multipartFormData: { (mul) in
            for (_,singleObject) in data.enumerated() {
                mul.append(singleObject.data, withName: singleObject.name, fileName: singleObject.fileName, mimeType: singleObject.mimeType)
            }
            guard let parameters = parameters else { return }
            for (key, value) in parameters {
                mul.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
        }, with: request)
        .validate().responseData { (response) in
            self.handleResponse(response, completion: completion)
        }
    }
}

extension APIRequestHandler where Self: URLRequestBuilder {

    func send<T: Decodable>(_ decoder: T.Type, data: [UploadData]? = nil, progress: ((Progress) -> Void)? = nil, completion: CallResponse<T>) {

        if let data = data {
            uploadToServerWith(decoder, data: data, request: self, parameters: self.parameters, progress: progress, completion: completion)
        } else {

            session.request(self).validate().responseData {(response) in
                self.handleResponse(response, completion: completion)
            }
        }
    }
}
