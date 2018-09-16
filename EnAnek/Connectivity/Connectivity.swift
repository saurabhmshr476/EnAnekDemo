//
//  Connectivity.swift
//  EnAnek
//
//  Created by user on 16/09/18.
//  Copyright © 2018 user. All rights reserved.
//

import Foundation
import Alamofire
class Connectivity {
    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
