//
//  Created on 30/10/2023
//  Copyright © Pavel Puzyrev. All rights reserved.
//

import Foundation
import Core_HTTPClient

public struct NoneModel: Decodable { }

public protocol APIRequest: HTTPRequest {
    associatedtype SuccessModel: Decodable = NoneModel
    associatedtype ErrorModel: Decodable = NoneModel

    func castError(_ error: Error) -> APIError<ErrorModel>
}

// MARK: - Default implementations
extension APIRequest {
    public func castError(_ error: Error) -> APIError<ErrorModel> {
        if let error = error as? APIError<ErrorModel> {
            error
        } else {
            .unknown(error)
        }
    }
}
