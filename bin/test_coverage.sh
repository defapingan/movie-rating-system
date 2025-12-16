#!/bin/bash

# Test coverage script for Movie Rating System
echo "=== Running Tests for Movie Rating System ==="
echo ""

# Run all tests
echo "1. Running unit tests..."
rails test

echo ""
echo "2. Running integration tests..."
rails test:integration

echo ""
echo "3. Running system tests..."
rails test:system

echo ""
echo "=== Test Summary ==="
echo "Total test files:"
find test -name "*test.rb" | wc -l

echo ""
echo "Test coverage details can be viewed in coverage/index.html"