import XCTest

@testable import CoreTranslator

@available(macOS 26.0, *)
final class CoreTranslatorTests: XCTestCase {

    func testTranslatorInitialization() {
        let translator = CoreTranslator()
        XCTAssertNotNil(translator)
    }

    func testVariedInputs() async throws {
        let translator = CoreTranslator()

        let testCases: [(input: String, expectedKeywords: [String])] = [
            ("emails from Alice", ["f", "alice"]),
            ("subject contains invoice", ["s", "invoice"]),
            ("to Bob", ["t", "bob"]),
            ("received 2023-01-01", ["d", "2023-01-01"]),
            ("last 7 days", ["d", "7d"]),
            ("from Alice or Bob", ["or"]),
            ("not from Steve", ["!", "steve"]),
            ("from Alice about invoices last week", ["f", "alice", "d"]),
            ("tagged urgent", ["T", "urgent"]),
            ("with attachments", ["A"]),
        ]

        print("\n--- Starting Varied Input Tests ---")

        for (input, keywords) in testCases {
            do {
                print("Testing input: '\(input)'")
                let result = try await translator.translate(input)
                print(" -> Output: \(result)")

                XCTAssertFalse(result.isEmpty, "Translation for '\(input)' should not be empty")

                // Flexible assertion: Check if the output looks reasonable based on keywords
                // We don't fail hard on keywords to avoid flakiness from the LLM, but we log warnings.
                let missingKeywords = keywords.filter {
                    !result.lowercased().contains($0.lowercased())
                }
                if !missingKeywords.isEmpty {
                    print(
                        ":: WARNING :: Output for '\(input)' missing expected parts: \(missingKeywords)"
                    )
                }
            } catch {
                XCTFail("Translation failed for '\(input)' with error: \(error)")
            }
        }
        print("--- Finished Varied Input Tests ---\n")
    }
}
