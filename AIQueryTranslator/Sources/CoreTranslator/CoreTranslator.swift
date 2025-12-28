import Foundation
import FoundationModels

@available(macOS 26.0, *)
public struct CoreTranslator {
  public init() {}

  public func translate(_ input: String) async throws -> String {
    guard let url = Bundle.module.url(forResource: "TranslationSystemPrompt", withExtension: "md"),
      let instructions = try? String(contentsOf: url, encoding: .utf8)
    else {
      fatalError("Failed to load TranslationSystemPrompt.md from bundle")
    }

    let session = LanguageModelSession(instructions: instructions)
    var options = GenerationOptions()
    options.temperature = 0.0
    let response = try await session.respond(to: input, options: options)
    return response.content.trimmingCharacters(in: .whitespacesAndNewlines)
  }
}
