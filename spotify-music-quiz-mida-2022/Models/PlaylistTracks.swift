//
//  PlaylistTracks.swift
//  spotify-music-quiz-mida-2022
//
//  Created by Antony Pascalino on 19/05/23.
//

import Foundation

struct PlaylistTracks: Codable {
    let description: String
    let external_urls : [String : String]
    let name : String
    let id : String
    let images : [APIImage]
    let tracks: PlaylistTracksResponse
}

struct PlaylistTracksResponse: Codable {
    var items: [PlaylistItem]
}

struct PlaylistItem : Codable {
    var track : Track?
}
