import ArgumentParser
import Foundation

@main
struct AIQueryTranslator: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Translates natural language to MailMate queries using local AI."
    )

    @Argument(help: "The natural language query to translate.")
    var query: String

    mutating func run() throws {
        // Placeholder for Foundation Models Framework integration
        let translatedQuery = translate(query)
        print(translatedQuery)
    }

    func translate(_ input: String) -> String {
        // TODO: Integrate actual Foundation Models Framework here.
        // For now, simple keyword matching as a fallback/mock.

        var parts: [String] = []
        let lower = input.lowercased()

        if lower.contains("from steve") {
            parts.append("from:\"Steve\"")
        }
        if lower.contains("last week") {
            parts.append("date:last_week")
        }
        if lower.contains("pdf") {
            parts.append("filename.extension:pdf")
        }

        if parts.isEmpty {
            // detailed tracing?
            return "subject:\"\(input)\""
        }

        return parts.joined(separator: " ")
    }
}
