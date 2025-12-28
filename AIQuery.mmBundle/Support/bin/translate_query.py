#!/usr/bin/env python3.11
"""
MailMate Query Translator

Converts natural language email search queries into MailMate search syntax
using the Gemini API.

Usage:
    python translate_query.py "emails from Alice about invoices this year"

Environment:
    GEMINI_API_KEY: Your Gemini API key
"""

import argparse
import os
import sys
from pathlib import Path

from google import genai
from google.genai import types


def load_system_prompt() -> str:
    """Load the system prompt from the markdown file."""
    script_dir = Path(__file__).parent
    prompt_path = script_dir / "AIQueryTranslator/Sources/CoreTranslator/Resources/TranslationSystemPrompt.md"
    
    if not prompt_path.exists():
        # Try relative to workspace root
        prompt_path = Path("AIQueryTranslator/Sources/CoreTranslator/Resources/TranslationSystemPrompt.md")
    
    if not prompt_path.exists():
        raise FileNotFoundError(f"Could not find TranslationSystemPrompt.md at {prompt_path}")
    
    return prompt_path.read_text(encoding="utf-8")


def translate_query(query: str) -> str:
    """Translate a natural language query to MailMate search syntax."""
    api_key = os.environ.get("GEMINI_API_KEY")
    
    if not api_key:
        raise ValueError("GEMINI_API_KEY environment variable is not set")
    
    client = genai.Client(api_key=api_key)
    system_prompt = load_system_prompt()
    
    response = client.models.generate_content(
        model="gemini-2.5-flash",
        contents=query,
        config=types.GenerateContentConfig(
            system_instruction=system_prompt,
            temperature=0.0,
            max_output_tokens=256,
        )
    )
    
    return response.text.strip()


def main():
    parser = argparse.ArgumentParser(
        description="Translate natural language email queries to MailMate search syntax"
    )
    parser.add_argument(
        "query",
        nargs="?",
        help="Natural language query to translate"
    )
    parser.add_argument(
        "--interactive", "-i",
        action="store_true",
        help="Run in interactive mode"
    )
    
    args = parser.parse_args()
    
    if args.interactive:
        print("MailMate Query Translator (type 'quit' to exit)")
        print("-" * 50)
        while True:
            try:
                query = input("\nQuery: ").strip()
                if query.lower() in ("quit", "exit", "q"):
                    break
                if not query:
                    continue
                result = translate_query(query)
                print(f"Result: {result}")
            except KeyboardInterrupt:
                print("\nExiting...")
                break
            except Exception as e:
                print(f"Error: {e}", file=sys.stderr)
    elif args.query:
        try:
            result = translate_query(args.query)
            print(result)
        except Exception as e:
            print(f"Error: {e}", file=sys.stderr)
            sys.exit(1)
    else:
        parser.print_help()
        sys.exit(1)


if __name__ == "__main__":
    main()
