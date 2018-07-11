//
//  Application.swift
//  CHTTPParser
//
//  Created by Muhammad Aunorafiq Musa on 11/07/18.
//

import Kitura
import LoggerAPI
import CouchDB
import Foundation

public class App {
    
    let router = Router()
    
    var client: CouchDBClient?
    var database: Database?
    
    public func run() {
        postInit()
        Kitura.addHTTPServer(onPort: 8080, with: router)
        Kitura.run()
    }
    
    private func postInit() {
        let connectionProperties = ConnectionProperties(host: "localhost", port: 5984, secured: false)
        
        client = CouchDBClient(connectionProperties: connectionProperties)
        
        client!.dbExists("acronyms") { exists, _ in
            guard exists else {
                self.createNewDatabase()
                return
            }
            Log.info("Acronyms database located - loading...")
            self.finalizeRoutes(with: Database(connProperties: connectionProperties, dbName: "acronyms"))
        }
    }
    
    private func createNewDatabase() {
        Log.info("Database does not exist - creating new database")
        
        client?.createDB("acronyms") { database, error in
            
            guard let database = database else {
                let errorReason = String(describing: error?.localizedDescription)
                Log.error("Could not create new database: (\(errorReason)) - acronym routes not created")
                return
            }
            self.finalizeRoutes(with: database)
        }
    }
    
    private func finalizeRoutes(with database: Database) {
        self.database = database
        initializeAcronymRoutes(app: self)
        Log.info("Acronym routes created")
    }
}
