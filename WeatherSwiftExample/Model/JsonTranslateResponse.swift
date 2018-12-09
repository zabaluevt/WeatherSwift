//
//  JsonTranslateResponse.swift
//  WeatherSwiftExample
//
//  Created by Ольга Забалуева on 05.12.2018.
//  Copyright © 2018 Тимофей Забалуев. All rights reserved.
//

import Foundation

struct JsonTranslateResponse: Codable {
    let code: Int?
    let lang: String?
    let text: [String]?
}
