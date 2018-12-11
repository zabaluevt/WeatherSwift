//
//  JsonResponseForFiveDays.swift
//  WeatherSwiftExample
//
//  Created by Ольга Забалуева on 04.12.2018.
//  Copyright © 2018 Тимофей Забалуев. All rights reserved.
//

import Foundation

struct JsonResponse: Codable {
    //let cod: Int?
    //let message: String?
    let cnt: Double?
    let list: [List]?
    let city: City?
    let coord: Coord?
    let weather: [Weather]?
    let base: String?
    let main: Main?
    let visibility: Int?
    let wind: Wind?
    let clouds: Clouds?
    let dt: Int?
    let sys: Sys?
    let id: Int?
    let name: String?
}

struct City: Codable {
    let id: Int?
    let name: String?
    let coord: Coord?
    let country: String?
}

struct Coord: Codable {
    let lat, lon: Double?
}

struct List: Codable {
    let dt: Double?
    let main: MainClass?
    let weather: [Weather]?
    let clouds: Clouds?
    let wind: Wind?
    let snow: Snow?
    let sys: Sys?
    let dtTxt: String?
}

struct Clouds: Codable {
    let all: Double?
}

struct MainClass: Codable {
    let temp, tempMin, tempMax, pressure: Double?
    let seaLevel, grndLevel: Double?
    let humidity: Double?
    let tempKf: Double?
}

struct Snow: Codable {
    let the3H: Double?
}

struct Sys: Codable {
    let type, id: Int?
    let message: Double?
    let country: String?
    let sunrise, sunset: Int?
}

struct Weather: Codable {
    let main: String?
    let description: String?
    let icon: String?
    let id: Int?
}

enum Description: String, Codable {
    case brokenClouds = "broken clouds"
    case clearSky = "clear sky"
    case fewClouds = "few clouds"
    case lightSnow = "light snow"
    case scatteredClouds = "scattered clouds"
    case mist = "mist"
}

struct Wind: Codable {
    let speed, deg: Double?
}

struct Main: Codable {
    let temp: Double?
    let pressure, humidity: Double?
    let tempMin, tempMax: Double?
}


