//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
@_spi(InternalAmplifyConfiguration) @testable import Amplify

class TestConfigHelper {

    static var useGen2Configuration: Bool {
        ProcessInfo.processInfo.arguments.contains("GEN2")
    }

    static func retrieveAmplifyConfiguration(forResource: String) throws -> AmplifyConfiguration {

        let data = try retrieve(forResource: forResource)
        return try AmplifyConfiguration.decodeAmplifyConfiguration(from: data)
    }

    static func retrieveAmplifyOutputsData(forResource: String) throws -> AmplifyOutputsData {
        let data = try retrieve(forResource: forResource)
        return try AmplifyOutputsData.decodeAmplifyOutputsData(from: data)
    }

    static func retrieveCredentials(forResource: String) throws -> [String: String] {
        let data = try retrieve(forResource: forResource)

        let jsonOptional = try JSONSerialization.jsonObject(with: data, options: []) as? [String: String]
        guard let json = jsonOptional else {
            throw "Could not deserialize `\(forResource)` into JSON object"
        }

        return json
    }

    static func retrieve(forResource: String) throws -> Data {
        guard let path = Bundle(for: self).path(forResource: forResource, ofType: "json") else {
            throw "Could not retrieve configuration file: \(forResource)"
        }

        let url = URL(fileURLWithPath: path)
        return try Data(contentsOf: url)
    }
}

extension String {
    var withUUID: String {
        "\(self)-\(UUID().uuidString)"
    }
}
