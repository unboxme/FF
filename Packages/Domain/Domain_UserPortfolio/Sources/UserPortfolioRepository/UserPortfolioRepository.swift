//
//  Created on 10/11/2023
//  Copyright © Pavel Puzyrev. All rights reserved.
//

import Combine
import Core_DataBaseStorage

public protocol UserPortfolioRepositoryProtocol: AnyObject {
    var updatesPublisher: AnyPublisher<UserPortfolio, Never> { get }

    func create(_ userPortfolio: UserPortfolio) async
    func read() async -> [UserPortfolio]
    func update(_ userPortfolio: UserPortfolio) async
    func delete(_ id: String) async
}

public final class UserPortfolioRepository: UserPortfolioRepositoryProtocol {
    // MARK: Public properties
    public var updatesPublisher: AnyPublisher<UserPortfolio, Never> {
        updatesSubject.eraseToAnyPublisher()
    }

    // MARK: Private properties
    private let updatesSubject = PassthroughSubject<UserPortfolio, Never>()
    private let dataBaseStorage: DataBaseStorageProtocol

    // MARK: Init
    public init(dataBaseStorage: DataBaseStorageProtocol) {
        self.dataBaseStorage = dataBaseStorage
    }

    // MARK: UserPortfolioRepositoryProtocol
    public func create(_ userPortfolio: UserPortfolio) async {
        await dataBaseStorage.save(userPortfolio)
    }

    public func read() async -> [UserPortfolio] {
        await dataBaseStorage.retrieveAll(of: UserPortfolio.self)
    }

    public func update(_ userPortfolio: UserPortfolio) async {
        await dataBaseStorage.save(userPortfolio)
        updatesSubject.send(userPortfolio)
    }

    public func delete(_ id: String) async {
        await dataBaseStorage.deleteAll(of: UserPortfolio.self) { $0.id == id }
    }
}
