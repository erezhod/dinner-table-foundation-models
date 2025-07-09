//
//  GetJokeTool.swift
//  Foundadtion
//
//  Created by Erez Hod on 6/7/25.
//

import Foundation
import FoundationModels

struct GetJokeTool: Tool {
    let name = "getJoke"
    let description = "Gets a new joke from an API"
    
    @Generable
    struct Arguments {
        @Guide(description: "A joke receieved from the API")
        let joke: String
    }
    
    func call(arguments: Arguments) async throws -> ToolOutput {
        guard let url = URL(string: "https://icanhazdadjoke.com/") else {
            return ToolOutput("Invalid API URL.")
        }

        struct DadJokeAPIResponse: Decodable {
            let id: String
            let joke: String
            let status: Int
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(DadJokeAPIResponse.self, from: data)

        print("API joke: ", response.joke)
        
        let generatedContent = GeneratedContent(properties: [
            "joke": response.joke
        ])
        
        return ToolOutput(generatedContent)
    }
}
