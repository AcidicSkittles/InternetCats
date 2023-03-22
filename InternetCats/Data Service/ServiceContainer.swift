//
//  ServiceContainer.swift
//  InternetCats
//
//  Created by Derek Buchanan on 2/28/23.
//

import Foundation
import Nuke

class ServiceContainer {
    static let shared = ServiceContainer()

    var catService: CatServiceType

    init() {
        // Setup services
        let network: NetworkServiceType = NetworkService()

        // Inject our network behavior into our cat service
        catService = CatService(network: network)
    }
}
