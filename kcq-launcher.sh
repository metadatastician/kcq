#!/usr/bin/env bash
# kcq Launcher Script
# SPDX-License-Identifier: MPL-2.0
# Copyright (c) 2026 Jonathan D.A. Jewell (hyperpolymath) <j.d.a.jewell@open.ac.uk>

# This script provides a convenient way to launch kcq
# It handles the just-based build system and provides useful commands

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Print the command list and exit 0. build, build-release, test and bench
# are listed but fail until AffineScript can compile the sources
# (docs/status/ROADMAP.adoc, Blockers).
usage() {
    echo "Usage: $(basename "$0") [COMMAND] [OPTIONS]"
    echo ""
    echo "kcq — Kubernetes Configuration Query"
    echo "AffineScript-based KYAML processor"
    echo ""
    echo "Commands:"
    echo "  build         - Build kcq (debug mode; not implemented yet)"
    echo "  build-release - Build kcq (release mode; not implemented yet)"
    echo "  test          - Run all tests (not implemented yet)"
    echo "  bench         - Run benchmarks (not implemented yet)"
    echo "  clean         - Clean build artifacts"
    echo "  validate      - Validate the repo layout and deed"
    echo "  install       - Install kcq system-wide (not implemented yet)"
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

# Print the version, licences and repository, then exit 0.
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