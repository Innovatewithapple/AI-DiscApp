//
//  Model.swift
//  Simple
//
//  Created by Himanshu vyas on 28/08/25.
//

import Foundation
struct APIResponse: Codable {
    let choices: [Choice]
}

struct Choice: Codable {
    let message: APIMessage
}

struct APIMessage: Codable {
    let role: String
    let content: String?
    let images: [APIImage]?
}

struct APIImage: Codable {
    let type: String
    let image_url: APIImageURL
}

struct APIImageURL: Codable {
    let url: String
}
