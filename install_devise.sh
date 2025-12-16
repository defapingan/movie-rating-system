#!/bin/bash
echo "=== Installing Devise ==="

echo "1. Adding Devise to Gemfile..."
echo "gem 'devise'" >> Gemfile

echo "2. Installing gems..."
bundle install

echo "3. Running Devise installer..."
rails generate devise:install

echo "4. Creating User model..."
rails generate devise User

echo "5. Running migrations..."
rails db:migrate

echo "6. Creating test fixtures..."
cat > test/fixtures/users.yml << 'USER_YML'
user_one:
  email: user1@example.com
  encrypted_password: <%= Devise::Encryptor.digest(User, 'password123') %>

user_two:
  email: user2@example.com
  encrypted_password: <%= Devise::Encryptor.digest(User, 'password123') %>
USER_YML

echo "7. Updating test_helper.rb..."
if ! grep -q "require 'devise'" test/test_helper.rb; then
  sed -i "1i require 'devise'" test/test_helper.rb
fi

if ! grep -q "include Devise::Test::IntegrationHelpers" test/test_helper.rb; then
  cat >> test/test_helper.rb << 'TEST_HELPER'

# Devise test helpers
include Devise::Test::IntegrationHelpers
include Devise::Test::ControllerHelpers
TEST_HELPER
fi

echo "8. Running tests..."
rails db:test:prepare
rails test

echo "=== Devise installation complete ==="
