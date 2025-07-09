//
//  ContentView.swift
//  Foundadtion
//
//  Created by Erez Hod on 5/7/25.
//

import FoundationModels
import SwiftUI

struct ContentView: View {
    private let session: LanguageModelSession

    @State private var messages = [Joke.PartiallyGenerated]()
    @State private var currentResponseState: ResponseState = .ready

    @State private var isShowingAlert: Bool = false
    @State private var alertTitle = ""
    @State private var alertBody = ""

    init() {
        let instructions = """
                Follow these instructions and only these instructions:
                - Always generate a joke using the `getJoke` tool.
                - For the `teenagerResponse` and `dadResponse` fields, generate them using your own abilities.
                - Always generate safe content.
            """

        session = LanguageModelSession(
            tools: [GetJokeTool()],
            instructions: instructions,
        )
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                if messages.isEmpty {
                    ContentUnavailableView(
                        "Dad is suspeciously silent",
                        systemImage: "mustache.fill",
                        description: Text("Tap on the magical button to let Dad embarrass you in front of everyone")
                    )
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12.0) {
                            ForEach(messages) { message in
                                if message.joke != nil {
                                    MessageBubbleView(
                                        avatarImage: "avatar_dad",
                                        direction: .received,
                                        text: message.joke ?? ""
                                    )
                                }

                                if message.teenagerResponse != nil {
                                    MessageBubbleView(
                                        avatarImage: "avatar_teenager",
                                        direction: .sent,
                                        text: message.teenagerResponse ?? ""
                                    )
                                }

                                if message.dadResponse != nil {
                                    MessageBubbleView(
                                        avatarImage: "avatar_dad",
                                        direction: .received,
                                        text: message.dadResponse ?? ""
                                    )
                                }
                            }
                        }
                        .padding(.bottom, 72.0)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }

                Button(currentResponseState.actionTitle, systemImage: "sparkles") {
                    Task {
                        await startTheEmbarassment()
                    }
                }
                .buttonStyle(.glassProminent)
                .tint(currentResponseState.actionColor)
                .controlSize(.large)
                .font(.title3)
                .disabled(currentResponseState == .generating)
            }
            .navigationTitle("Dinner Table")
            .navigationBarTitleDisplayMode(.large)
            .alert(alertTitle, isPresented: $isShowingAlert) {
                
            } message: {
                Text(alertBody)
            }
        }
    }
}

// MARK: - Actions

extension ContentView {
    func startTheEmbarassment() async {
        currentResponseState = .generating

        let prompt = """
            Get a joke using the `getJoke` tool and use it. Don't generate one yourself.
            """

        do {
            let streamResponse = session.streamResponse(
                to: prompt,
                generating: Joke.self,
                options: GenerationOptions(
                    temperature: 1.2,  // Change this and test the result!
                    maximumResponseTokens: 2_000  // Sets the maximum context window
                )
            )

            for try await partial in streamResponse {
                if let firstIndex = messages.firstIndex(where: { $0.id == partial.id }) {
                    messages[firstIndex] = partial
                } else {
                    messages.append(partial)
                }
            }

            alertTitle = ""
            alertBody = ""
        } catch LanguageModelSession.GenerationError.guardrailViolation(let context) {
            print(context.debugDescription)
            alertTitle = "Safety first"
            alertBody = "The generated content was flagged as unsafe and therefore, cannot be displayed."
            isShowingAlert = true
        } catch LanguageModelSession.GenerationError.exceededContextWindowSize(let context) {
            print("Exceeded context size (max tokens):", context.debugDescription)
        } catch {
            print(error.localizedDescription)
            alertTitle = "Oops..."
            alertBody = "Something went wrong. Please try again later."
            isShowingAlert = true
        }

        currentResponseState = .ready
    }
}

#Preview {
    ContentView()
}
