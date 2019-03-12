//
//  URLConstants.swift
//  MyHealthApp
//
//  Created by Stuti on 12/10/18.
//  Copyright © 2018 iOS. All rights reserved.
//

import Foundation

let baseURL = "api.genes.com/v1"

let loginPostURL = baseURL + "/customer/login"
let logoutPostURL = baseURL + "/customer/logout"
let lifestylePostURL = baseURL + "/customer/%@/heartrate"

let getCustomerDataURL = baseURL + "/customer/%@/user"
let getCustomerGeneticsDataURL = baseURL + "/customer/%@/genetic"

