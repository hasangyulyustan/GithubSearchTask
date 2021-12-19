import Foundation
/**
 Configuration stuct is  used to retrive configuration parameters from the config file.
 The config file is config.plist .

 Multiple environments are supported.
 Environments are places under the "modes" key.
 Default environment is "Debug".
 */
struct Configuration {
    /**
     Retrieves the value stored under the key from the config file.
     First it checkes the current environment and if no value is present it checks the root of the config file.
     @param key the key for the requested value
     @return the value if found or nil
     */
    static func get(key: String) -> Any? {
        if  let pathToFile = Configuration.configFile() {
            let dict = NSDictionary(contentsOfFile: pathToFile)!
            let newDict = dict as! [String:Any]
            if let conf = Configuration.getModeConfig(rootDictionary: newDict, environment: Configuration.currentEnvironment())[key] {
                return conf
            }
            return dict[key]
        }
        return nil
    }
    /**
     Sets the environment. The environment is saved in the user defaults.
     @param env the new environment.
     */
    mutating func setEnvironment(env: String) {
        let defaults = UserDefaults.standard
        defaults.set(env, forKey: Constants.ConfigurationStrings.environment)
    }
}

private extension Configuration {

    static func configFile() -> String? {
        return Bundle.main.path(forResource: "config", ofType: "plist")
    }
    /**
     Gets the enviroment. If the enviroment is saved in user defaults, it will return it. If environment is not found in UserDefault environment mode will be taken from Build environments
     */
    static func currentEnvironment() -> String {
        if let env = UserDefaults.standard.string(forKey: Constants.ConfigurationStrings.environment) {
            return env
        } else if let env =  Bundle.main.infoDictionary?[Constants.ConfigurationStrings.environment] as? String {
            return env
        }
        return "develop"  // return if envoremnt could not be found
    }
    /**
     Gets the modes section from config.plist
     modes are based on environments
     */
    static func getModeConfig(rootDictionary : [String : Any], environment : String) -> [String : Any] {
        let modeDictionary = rootDictionary[Constants.ConfigurationStrings.modes] as! [String : Any]
        return modeDictionary[environment] as! [String : Any]
    }
}
