import ArgumentParser
import CoreTranslator
import Foundation
import FoundationModels  // New in iOS 26 / macOS 26.[web:25]

@main
struct AIQueryTranslator: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Translates natural language to MailMate queries using local AI."
    )

    @Argument(parsing: .captureForPassthrough, help: "The natural language query to translate.")
    var queryWords: [String] = []

    var query: String {
        queryWords.joined(separator: " ")
    }

    mutating func run() throws {
        let sema = DispatchSemaphore(value: 0)

        let promptQuery = query  // capture

        if #available(macOS 26.0, *) {
            Task {
                do {
                    let translator = CoreTranslator()
                    let translatedQuery = try await translator.translate(promptQuery)
                    print(translatedQuery)
                } catch {
                    // Fallback or print error
                    print("subject:\"\(promptQuery)\"")
                }
                sema.signal()
            }
            sema.wait()
        } else {
            print("subject:\"\(promptQuery)\"")
        }
    }
}
