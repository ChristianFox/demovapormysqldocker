import Vapor
import FluentMySQL

/// Called before your application initializes.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#configureswift)
public func configure(
    _ config: inout Config,
    _ env: inout Environment,
    _ services: inout Services
) throws {
    
    print("<SimpleSQL App> Will configure")
    
    // Register providers first
    try services.register(FluentMySQLProvider())
    
    // Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)
    
    // Configure the rest of your application here
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)
    
    // Configure a MySQL database
    let host = Environment.get("MYSQL_HOST") ?? "localhost"
    let user = Environment.get("MYSQL_USER") ?? "user"
    let pass = Environment.get("MYSQL_PASSWORD") ?? "password"
    var port = 3306
    if let param = Environment.get("MYSQL_PORT"),
        let newPort = Int(param) {
        port = newPort
    }
    
    let dbConfig:MySQLDatabaseConfig
    let db = Environment.get("MYSQL_DATABASE") ?? "database1"
    print("<SimpleSQL App> \(db), \(port), \(user)@\(host), \(pass)")
    dbConfig = MySQLDatabaseConfig(
        hostname: host,
        port:port,
        username: user,
        password: pass,
        database: db,
        transport: MySQLTransportConfig.unverifiedTLS
    )
    
    let sqlDB = MySQLDatabase(config: dbConfig)
    
    // Register the configured MySQL database to the database config.
    var databases = DatabasesConfig()
    databases.add(database: sqlDB, as: .mysql)
    services.register(databases)
    
    // Configure migrations
    var migrations = MigrationConfig()
    migrations.add(model: Thing.self, database: .mysql)
    services.register(migrations)
    
}
