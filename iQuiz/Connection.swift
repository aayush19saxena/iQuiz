//
//  Connection.swift
//  iQuiz
//
//  Created by Aayush  Saxena on 2/19/18.
//  Copyright © 2018 Aayush  Saxena. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration

protocol Utilities {
}

extension NSObject:Utilities{
    
    
    enum ConnectionStatus {
        case notReachable
        case reachable
    }
    
    var currentConnectionStatus: ConnectionStatus {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        var flags: SCNetworkReachabilityFlags = []
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return .notReachable
        }
        
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return .notReachable
        }
        else if flags.contains(.isWWAN) == true {
            return .reachable
        }
        
        if flags.contains(.reachable) == false {
            return .notReachable
        }
            
        else if flags.contains(.connectionRequired) == false {
            return .reachable
        }
        else if (flags.contains(.connectionOnDemand) == true || flags.contains(.connectionOnTraffic) == true) && flags.contains(.interventionRequired) == false {
            return .reachable
        }
        else {
            return .notReachable
        }
    }
    
}
