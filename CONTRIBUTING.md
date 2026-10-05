// SPDX-License-Identifier: CC-BY-SA-4.0
// Copyright (c) 2026 Jonathan D.A. Jewell (hyperpolymath) <j.d.a.jewell@open.ac.uk>

# Contributing to kcq

We welcome contributions! This document outlines how to contribute to kcq.

## Development Setup

### Prerequisites

1. **AffineScript Compiler**
   ```bash
   git clone https://github.com/hyperpolymath/affinescript
   cd affinescript
   # Follow setup instructions in affinescript/README.md
   ```

2. **OCaml Toolchain** (for AffineScript core)
   ```bash
   # On Debian/Ubuntu
   sudo apt-get install ocaml opam
   opam init
   opam install dune merlin
   ```

3. **Rust Toolchain** (for WASM compilation)
   ```bash
   curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
   source ~/.cargo/env
   ```

### Building kcq

```bash
# Clone the repository
cd /home/hyperpolymath/developer/meta-repos/kcq

# Build the AffineScript core
make build

# Run tests
make test

# Build WASM version
make wasm
```

### Project Structure

```
kcq/
├── src/
│   └── Kyaml/
│       ├── Lexer.affine       # Tokenizer for KYAML
│       ├── Parser.affine      # Parser to build AST
│       ├── Ast.affine         # Abstract Syntax Tree types
│       ├── Lint/              # Lint rules
│       │   ├── RequiredFields.affine
│       │   ├── TypeCheck.affine
│       │   └── ...
│       ├── Query/             # Query engine
│       │   ├── Path.affine
│       │   └── Filter.affine
│       └── Schema/            # K8s schemas
│           ├── Deployment.affine
│           ├── Service.affine
│           └── ...
├── test/
│   ├── fixtures/              # Test YAML files
│   │   ├── deployment.yaml
│   │   ├── service.yaml
│   │   └── ...
│   └── Test.affine            # Test suite
├── examples/                  # Example usage
├── Makefile                  # Build scripts
├── README.md
└── LICENSE
```

## Writing Code

### AffineScript Style Guide

1. **Use LucidScript face** (Haskell-like syntax) for kcq
2. **Type everything** — AffineScript's type system is your friend
3. **Keep functions pure** where possible
4. **Use affine types** for resource management (file handles, memory)
5. **Document functions** with comments
6. **Handle errors explicitly** — don't use partial functions

### Example Module Structure

```affine
-- src/Kyaml/Parser.affine
module Kyaml.Parser where

import Kyaml.Lexer
import Kyaml.Ast

-- Parse KYAML input into AST
parseKyaml :: string -> Result<KYamlDoc, ParseError>
parseKyaml input = do
  tokens <- lex input
  parseTokens tokens

-- Internal: parse token stream
parseTokens :: list<Token> -> Result<KYamlDoc, ParseError>
parseTokens = -- implementation
```

### Adding a Lint Rule

1. Create a new file in `src/Kyaml/Lint/`
2. Implement the rule as a function with signature:
   ```affine
   type LintRule = KYamlDoc -> list<LintIssue>
   
   type LintIssue = {
     severity: Severity,  -- Error, Warning, Info
     message: string,
     path: list<string>,  -- Field path
     line: int,
     column: int
   }
   
   checkLatestTag :: LintRule
   checkLatestTag doc = -- implementation
   ```
3. Register the rule in `src/Kyaml/Lint/Registry.affine`

## Testing

### Running Tests

```bash
make test
```

### Adding Tests

Add test YAML files to `test/fixtures/` and corresponding test cases to `test/Test.affine`:

```affine
module Test where

import Kyaml.Parser
import Kyaml.Lint

-- Test: parse a simple deployment
testParseDeployment :: IO ()
testParseDeployment = do
  content <- readFile "test/fixtures/deployment.yaml"
  case parseKyaml content of
    Ok doc -> assert (doc.kind == "Deployment")
    Err e -> fail (show e)

-- Test: lint catches latest tag
testLintLatestTag :: IO ()
testLintLatestTag = do
  content <- readFile "test/fixtures/latest-tag.yaml"
  case parseKyaml content of
    Ok doc ->
      let issues = lintDoc doc
      assert (any (\(issue) -> issue.ruleId == "latest-tag") issues)
    Err e -> fail (show e)
```

## Submitting Changes

1. **Fork the repository** (if you don't have push access)
2. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```
3. **Make your changes**
4. **Add tests** for new functionality
5. **Update documentation** (README, docs)
6. **Run tests**
   ```bash
   make test
   ```
7. **Commit your changes**
   ```bash
   git commit -m "Add your feature description"
   ```
8. **Push to the branch**
   ```bash
   git push origin feature/your-feature-name
   ```
9. **Open a Pull Request**

### Pull Request Guidelines

- Use a **clear, descriptive title**
- Provide a **detailed description** of changes
- Reference any **related issues**
- Include **screenshots or examples** if applicable
- Ensure all **tests pass**
- Update **documentation** as needed

### Commit Message Guidelines

- Use **imperative mood** ("Add feature" not "Added feature")
- Keep the **first line under 50 characters**
- Separate subject from body with a **blank line**
- Wrap the body at **72 characters**
- Explain **what** and **why**, not just **how**

Example:
```
Add selector validation lint rule

This rule checks that spec.selector.matchLabels matches
spec.template.metadata.labels in Deployment resources.

Fixes #123
```

## Code Review Process

1. **Initial review** by maintainers (1-2 days)
2. **Feedback** on design, implementation, tests
3. **Revisions** by contributor
4. **Final approval** and merge

We aim to review PRs within **2 business days**.

## Reporting Issues

When reporting issues, please include:

1. **Version** of kcq
2. **Operating system**
3. **Steps to reproduce**
4. **Expected behavior**
5. **Actual behavior**
6. **Sample input** (if applicable)

## Community

- **Discussions**: Use GitHub Discussions for questions and ideas
- **Issues**: Use GitHub Issues for bug reports and feature requests
- **Chat**: Join the [hyperpolymath Discord](https://discord.gg/...) for real-time discussion

## License

By contributing to kcq, you agree that your contributions will be licensed under the **Apache License 2.0**. See [LICENSE](LICENSE) for details.
