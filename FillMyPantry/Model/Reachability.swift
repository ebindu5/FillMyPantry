//
//  Reachability.swift
//  FillMyPantry
//
//  Created by NISHANTH NAGELLA on 8/10/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import Firebase


class Reachability {
   static func isNetworkConnectionAvailble()->Bool{
        let connectedRef = Database.database().reference(withPath: ".info/connected")
       var success = false
        connectedRef.observe(.value, with: { snapshot in
            if let connected = snapshot.value as? Bool, connected {
               success = true
            } else {
               success = false
            }
        })
        return success
    }

}

