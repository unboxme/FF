//
//  Created on 04/11/2023
//  Copyright © Pavel Puzyrev. All rights reserved.
//

import Foundation
import RealmSwift

public protocol DataBaseStorageProtocol: Actor {
    func save<T: DataBaseStorable>(_ models: [T]) async
    func save<T: DataBaseStorable>(_ model: T) async

    func retrieveAll<T: DataBaseStorable>(of type: T.Type, where predicate: ((T.DataBaseModel) -> Bool)) async -> [T]
    func retrieveAll<T: DataBaseStorable>(of type: T.Type) async -> [T]

    func deleteAll<T: DataBaseStorable>(of type: T.Type, where predicate: ((T.DataBaseModel) -> Bool)) async
    func deleteAll<T: DataBaseStorable>(of type: T.Type) async
}

public actor DataBaseStorage: DataBaseStorageProtocol {
    // MARK: Private properties
    private var realm: Realm!

    // MARK: Init
    public init() async {
        self.realm = try! await Realm(actor: self)
    }

    // MARK: DataBaseStorageProtocol
    public func save<T: DataBaseStorable>(_ models: [T]) async {
        let objects = models.map { $0.makeDataBaseModel() }

        try? await realm.asyncWrite {
            realm.add(objects, update: .modified)
        }
    }

    public func save<T: DataBaseStorable>(_ model: T) async {
        await save([model])
    }

    public func retrieveAll<T: DataBaseStorable>(
        of type: T.Type,
        where predicate: ((T.DataBaseModel) -> Bool)
    ) async -> [T] {
        realm
            .objects(type.DataBaseModel.self)
            .filter(predicate)
            .map { T.make(from: $0) }
    }

    public func retrieveAll<T: DataBaseStorable>(of type: T.Type) async -> [T] {
        await retrieveAll(of: type) { _ in true }
    }

    public func deleteAll<T: DataBaseStorable>(
        of type: T.Type,
        where predicate: ((T.DataBaseModel) -> Bool)
    ) async {
        let objects = realm
            .objects(type.DataBaseModel.self)
            .filter(predicate)

        try? await realm.asyncWrite {
            realm.delete(objects)
        }
    }

    public func deleteAll<T: DataBaseStorable>(of type: T.Type) async {
        await deleteAll(of: type) { _ in true }
    }
}
