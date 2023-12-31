//
//  Created on 03/11/2023
//  Copyright © Pavel Puzyrev. All rights reserved.
//

import Foundation
import Core_Utils
import Core_API
import Core_HTTPClient

public protocol FastForexAPIProtocol: API { }

public final class FastForexAPI: FastForexAPIProtocol {
    // MARK: Types
    public enum Endpoint { }

    // MARK: Public properties
    public let httpClient: HTTPClientProtocol
    public let successResponseDecoder: JSONDecoder?
    public let commonParameters: URLQueryItemsConvertible

    // MARK: Init
    public init(
        httpClient: HTTPClientProtocol,
        commonParameters: URLQueryItemsConvertible
    ) {
        let successResponseDecoder = JSONDecoder()
        successResponseDecoder.keyDecodingStrategy = .convertFromSnakeCase

        self.httpClient = httpClient
        self.successResponseDecoder = successResponseDecoder
        self.commonParameters = commonParameters

        httpClient.requestModifiersSource = self
    }
}
