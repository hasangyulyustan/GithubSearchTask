import Foundation
import Alamofire

protocol HandleAlamoResponse {
    /// Handles request response, never called anywhere but APIRequestHandler
    ///
    /// - Parameters:
    ///   - response: response from network request, for now alamofire Data response
    ///   - completion: completing processing the json response, and delivering it in the completion handler
    func handleResponse<T: Decodable>(_ response: DataResponse<Data,AFError>, completion: CallResponse<T>)
}

extension HandleAlamoResponse {

    func handleResponse<T: Decodable>(_ response: DataResponse<Data,AFError>, completion: CallResponse<T>) {
        let code = response.response?.statusCode ?? 0
        switch response.result {
        case .failure(_):

            do {
                let error = try ErrorModel(data: response.data ?? Data())
                completion?(ServerResponse<T>.failure(code, error, nil))
                
            } catch {
                var message = [[String:String]]()
                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: response.data ?? Data(), options: .mutableContainers) as? [String: Any]
                    for (key, value) in jsonObject! {
                        if key == "errors" {
                            let errors = value as? [String: Array<String>]
                            for (a, b) in errors! {
                                message.append(["\(a)":"\(b.first ?? "")"])
                            }
                        }
                    }

                } catch {
                    if let string = NSString(data: response.data ?? Data(), encoding: String.Encoding.utf8.rawValue) {

                        print(string)
                    }
                }

                if response.response?.statusCode == 200 {
                    if let responseData = response.data, T.self == Data.self {
                        completion?(ServerResponse<T>.success(responseData as? T))
                    } else {
                        completion?(ServerResponse<T>.success(nil))
                    }
                } else {
                    completion?(ServerResponse<T>.failure(code, ErrorModel(message: error.localizedDescription, failures: nil), message))
                }
            }

        case .success(let value):

            if T.self == Bool.self {
                completion?(ServerResponse<T>.success(true as? T))
                return
            }

            if T.self == Void.self {
                completion?(ServerResponse<T>.success(() as? T))
                return
            }

            do {
                let modules = try T(data: value)
                completion?(ServerResponse<T>.success(modules))
            } catch(let error) {
                #if DEBUG
                print(error)
                print("===== WARNING: Empty result or unable to parse as \(String(describing: T.self)) : /n \(value)")
                print(error)
                #endif
                completion?(ServerResponse<T>.success(nil))
            }
        }
    }
}
