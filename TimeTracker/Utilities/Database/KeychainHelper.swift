import KeychainAccess

struct KeychainHelper {
    private let keychain = Keychain(service: "com.example.yourapp")
    private let sqlitePathKey = "timeTrackerSqlitePath"

    func isFirstLaunch() -> Bool {
        getDatabasePath() == nil
    }

    func saveDatabasePath(path: String) {
        do {
            try keychain.set(path, key: sqlitePathKey)
        } catch {
            print("Error saving to keychain: \(error)")
        }
    }

    func getDatabasePath() -> String? {
        do {
//            remove(sqlitePathKey)
            return try keychain.get(sqlitePathKey)
        } catch {
            print(error)
            return nil
        }
    }

    func remove(_ key: String, ignoringAttributeSynchronizable: Bool = true) {
        do {
            try keychain.remove(
                key,
                ignoringAttributeSynchronizable: ignoringAttributeSynchronizable
            )
        } catch {
            print(error)
        }
    }
}
