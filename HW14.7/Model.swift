//
//  Model.swift
//  HW12.6
//
//  Created by Илья Перевозкин on 16.08.2022.
//

import Foundation

struct General: Decodable {
    let info: Information
    let results: [Character]
    
    enum CodingKeys: CodingKey {
        case info, results
    }
   
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        info = try container.decode(Information.self, forKey: .info)
        results = try container.decode([Character].self, forKey: .results)
    }
}

struct Information: Decodable {
    let count: Int
    let pages: Int
    let next: String
    let prev: String?
    
    enum CodingKeys: CodingKey {
        case count, pages, next, prev
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        count = try container.decode(Int.self, forKey: .count)
        pages = try container.decode(Int.self, forKey: .pages)
        next = try container.decode(String.self, forKey: .next)
        prev = try container.decode(String?.self, forKey: .prev)
    }
}

struct Character: Decodable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let origin: Origin
    let location: Location
    let image: String
    let episode: [String]
    let url: String
    let created: String
    
    enum CodingKeys: CodingKey {
        case id, name, status, species, type, gender, origin, location, image, episode, url, created
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        status = try container.decode(String.self, forKey: .status)
        species = try container.decode(String.self, forKey: .species)
        type = try container.decode(String.self, forKey: .type)
        gender = try container.decode(String.self, forKey: .gender)
        origin = try container.decode(Origin.self, forKey: .origin)
        location = try container.decode(Location.self, forKey: .location)
        image = try container.decode(String.self, forKey: .image)
        episode = try container.decode([String].self, forKey: .episode)
        url = try container.decode(String.self, forKey: .url)
        created = try container.decode(String.self, forKey: .created)
    }
}

struct Origin: Decodable {
    let name: String
    let url: String
    
    enum CodingKeys: CodingKey {
        case name, url
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        url = try container.decode(String.self, forKey: .url)
    }
}

struct Location: Decodable {
    let name: String
    let url: String
    
    enum CodingKeys: CodingKey {
        case name, url
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        url = try container.decode(String.self, forKey: .url)
    }
}

struct Episode: Decodable {
    let name: String
    
    enum CodingKeys: CodingKey {
        case name
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
    }
}
