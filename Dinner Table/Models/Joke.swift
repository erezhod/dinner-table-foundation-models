//
//  DadJoke.swift
//  Foundadtion
//
//  Created by Erez Hod on 5/7/25.
//

import Foundation
import FoundationModels

@Generable
struct Joke: Codable, Identifiable {
    var id = UUID()

    @Guide(description: "The generated joke from the `getJoke` tool")
    let joke: String

    @Guide(description: "A cringy complaint by a teenager about the last joke made by his dad. Use no more than 2 sentences")
    let teenagerResponse: String

    @Guide(description: "A creative and funny response by dad to the last teenager response")
    let dadResponse: String
}
