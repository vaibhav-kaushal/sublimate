import struct Vapor.Abort
import Fluent

public extension Array where Element: Model {
    func delete(on subl: Sublimate) throws {
        try delete(on: subl.db).wait()
    }

    @discardableResult
    func create(on subl: Sublimate) throws -> [Element] {
        try create(on: subl.db).wait()
        return self
    }
}

public extension Model {
    static func query(on subl: Sublimate) -> SublimateQueryBuilder<Self> {
        return SublimateQueryBuilder(qb: query(on: subl.db))
    }

    static func find(_ id: IDValue?, on subl: Sublimate) throws -> Self? {
        if let id = id {
            return try find(id, on: subl.db).wait()
        } else {
            return nil
        }
    }

    func delete(on subl: Sublimate) throws -> Void {
        return try delete(on: subl.db).wait()
    }

    @discardableResult
    func save(on subl: Sublimate) throws -> Self {
        try save(on: subl.db).wait()
        return self
    }

    static func findOrAbort(_ id: IDValue, on subl: Sublimate, file: String = #file, line: UInt = #line) throws -> Self {
        let e = Abort(.notFound, reason: "\(type(of: self)) not found for ID: \(id)", file: file, line: line)
        return try find(id, on: subl.db).unwrap(or: e).wait()
    }
}

public extension ParentProperty {
    func query(on subl: Sublimate) -> SublimateQueryBuilder<To> {
        .init(qb: query(on: subl.db))
    }

    func get(on subl: Sublimate) throws -> To {
        try query(on: subl).one()
    }
}

public extension ChildrenProperty {
    func query(on subl: Sublimate) -> SublimateQueryBuilder<To> {
        .init(qb: query(on: subl.db))
    }

    func all(on subl: Sublimate) throws -> [To] {
        try query(on: subl.db).all().wait()
    }
}
