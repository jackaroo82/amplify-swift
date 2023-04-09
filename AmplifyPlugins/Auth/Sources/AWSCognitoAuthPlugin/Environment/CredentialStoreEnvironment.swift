//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import AWSPluginsCore
import Amplify
import Foundation

struct CredentialEnvironment: Environment, LoggerProvider {
    let authConfiguration: AuthConfiguration
    let credentialStoreEnvironment: CredentialStoreEnvironment
    let logger: Logger
}

extension CredentialEnvironment {
    func getCredentialsStoreAccessGroup() -> String? {
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist") {
            let dict = NSDictionary(contentsOfFile: path)
            let accessGroup = dict?.object(forKey: "AmplfiyCredentialsStoreAccessGroup") as? String
            return accessGroup
        }
        return nil
    }
}

protocol CredentialStoreEnvironment: Environment {
    typealias AmplifyAuthCredentialStoreFactory = (_ accessGroup: String?) -> AmplifyAuthCredentialStoreBehavior
    typealias KeychainStoreFactory = (_ service: String) -> KeychainStoreBehavior

    var amplifyCredentialStoreFactory: AmplifyAuthCredentialStoreFactory { get }
    var nonSharedAmplifyCredentialStoreFactory: AmplifyAuthCredentialStoreFactory { get }
    var legacyKeychainStoreFactory: KeychainStoreFactory { get }
    var eventIDFactory: EventIDFactory { get }
}

struct BasicCredentialStoreEnvironment: CredentialStoreEnvironment {

    typealias AmplifyAuthCredentialStoreFactory = (_ accessGroup: String?) -> AmplifyAuthCredentialStoreBehavior
    typealias KeychainStoreFactory = (_ service: String) -> KeychainStoreBehavior

    // Required
    let amplifyCredentialStoreFactory: AmplifyAuthCredentialStoreFactory
    let nonSharedAmplifyCredentialStoreFactory: AmplifyAuthCredentialStoreFactory
    let legacyKeychainStoreFactory: KeychainStoreFactory

    // Optional
    let eventIDFactory: EventIDFactory

    init(amplifyCredentialStoreFactory: @escaping AmplifyAuthCredentialStoreFactory, nonSharedAmplifyCredentialStoreFactory: @escaping AmplifyAuthCredentialStoreFactory,
         legacyKeychainStoreFactory: @escaping KeychainStoreFactory,
         eventIDFactory: @escaping EventIDFactory = UUIDFactory.factory) {
        self.amplifyCredentialStoreFactory = amplifyCredentialStoreFactory
        self.nonSharedAmplifyCredentialStoreFactory = nonSharedAmplifyCredentialStoreFactory
        self.legacyKeychainStoreFactory = legacyKeychainStoreFactory
        self.eventIDFactory = eventIDFactory
    }
}
