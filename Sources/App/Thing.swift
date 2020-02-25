
import Vapor
import FluentMySQL

struct Thing : MySQLModel {
    var id: Int?
}

extension Thing : Content { }
extension Thing : Migration { }
