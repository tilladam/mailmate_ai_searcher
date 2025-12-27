# MailMate AI Searcher Plugin

This project implements a MailMate bundle (`AIQuery.mmBundle`) that allows users to search for messages using natural language, powered by local Apple Intelligence (Foundation Models).

## Architecture
- **AIQueryTranslator**: A Swift-based CLI tool that translates natural language queries into MailMate search specifiers.
- **AIQuery.mmBundle**: The MailMate plugin wrapper that invokes the CLI tool via `Support/bin/translate_query.sh`.

## Prerequisites
- macOS 15+ (for Foundation Models support)
- MailMate
- Swift installed

## Building
Run the build script to compile the Swift tool and assemble the bundle:
```bash
./build_bundle.sh
```

## Installing
Run the install script to copy the bundle to MailMate's support directory:
```bash
./install.sh
```
After installation, strictly **restart MailMate**.

## Usage
1. Open MailMate.
2. Select the command `AI Search...` from the Command menu (or verify key binding).
3. Enter your natural language query (e.g. "Emails from Steve last week").
4. MailMate will open a search window with the translated query.

## Customization
The translation logic is currently located in `AIQueryTranslator/Sources/AIQueryTranslator/AIQueryTranslator.swift`.
To use the real `FoundationModels` API, edit that file to call the framework methods.
