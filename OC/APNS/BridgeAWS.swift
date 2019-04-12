//
//  BridgeAWS.swift
//  APNS
//
//  Created by ll on 2019/4/11.
//  Copyright © 2019 lenovo. All rights reserved.
//

import UIKit
import AWSMobileClient
@objcMembers

class BridgeAWS: NSObject {
   
    func initialize() {
        AWSMobileClient.sharedInstance().initialize { (userState, error) in
            if let error = error {
                print("Error initializing AWSMobileClient: \(error.localizedDescription)")
            } else if let userState = userState {
                print("AWSMobileClient initialized. Current UserState: \(userState.rawValue)")
            }
        }
    }

}
