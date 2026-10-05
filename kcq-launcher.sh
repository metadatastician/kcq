#!/usr/bin/env bash
# kcq Launcher Script
# SPDX-License-Identifier: MPL-2.0
# Copyright (c) 2026 Jonathan D.A. Jewell (hyperpolymath) <j.d.a.jewell@open.ac.uk>

# This script provides a convenient way to launch kcq
# It handles the just-based build system and provides useful commands

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="${SCRIPT_DIR}/bin"

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to show usage
usage() {
    echo "Usage: $(basename "$0") [COMMAND] [OPTIONS]"
    echo ""
    echo "kcq — Kubernetes Configuration Query"
    echo "AffineScript-based KYAML processor"
    echo ""
    echo "Commands:"
    echo "  build         - Build kcq (debug mode)"
    echo "  build-release - Build kcq (release mode)"
    echo "  test          - Run all tests"
    echo "  bench         - Run benchmarks"
    echo "  lint          - Lint source files"
    echo "  fmt           - Format source files"
    echo "  clean         - Clean build artifacts"
    echo "  validate      - Validate RSR compliance"
    echo "  install       - Install kcq system-wide"
    echo "  deps          - Install dependencies"
    echo "  ai-setup      - AI-assisted setup"
    echo "  just          - Run just commands directly"
    echo ""
    echo "Options:"
    echo "  -h, --help    - Show this help message"
    echo "  -v, --version - Show version information"
    echo ""
    echo "Examples:"
    echo "  $(basename "$0") build"
    echo "  $(basename "$0") test"
    echo "  $(basename "$0") just --list"
    exit 0
}

# Function to show version
version() {
    echo "kcq v0.1.0 — Kubernetes Configuration Query"
    echo "AffineScript KYAML Processor"
    echo "License: MPL-2.0 (code) / CC-BY-SA-4.0 (docs)"
    echo "Repository: metadatastician/kcq"
    exit 0
}

# Parse arguments
case "${1:-}" in
    -h|--help|help)
        usage
        ;;
    -v|--version)
        version
        ;;
    build)
        echo "Building kcq..."
        cd "${SCRIPT_DIR}"
        just build
        ;;
    build-release)
        echo "Building kcq (release mode)..."
        cd "${SCRIPT_DIR}"
        just build-release
        ;;
    test)
        echo "Running kcq tests..."
        cd "${SCRIPT_DIR}"
        just test
        ;;
    bench)
        echo "Running kcq benchmarks..."
        cd "${SCRIPT_DIR}"
        just bench
        ;;
    lint)
        echo "Linting kcq source files..."
        cd "${SCRIPT_DIR}"
        just lint
        ;;
    fmt)
        echo "Formatting kcq source files..."
        cd "${SCRIPT_DIR}"
        just fmt
        ;;
    clean)
        echo "Cleaning kcq build artifacts..."
        cd "${SCRIPT_DIR}"
        just clean
        ;;
    validate)
        echo "Validating kcq RSR compliance..."
        cd "${SCRIPT_DIR}"
        just validate
        ;;
    install)
        echo "Installing kcq system-wide..."
        cd "${SCRIPT_DIR}"
        just install
        ;;
    deps)
        echo "Setting up kcq dependencies..."
        cd "${SCRIPT_DIR}"
        just deps
        ;;
    ai-setup)
        echo "Running AI-assisted kcq setup..."
        cd "${SCRIPT_DIR}"
        just ai-setup
        ;;
    just)
        shift
        echo "Running just commands: $*"
        cd "${SCRIPT_DIR}"
        just "$@"
        ;;
    "")
        # No arguments - show help
        usage
        ;;
    *)
        echo "Error: Unknown command '${1:-}'" >&2
        echo "Run '$(basename "$0") --help' for usage information" >&2
        exit 1
        ;;
esac

exit 0