# test/application_system_test_case.rb
require "test_helper"
require "warden/test/helpers"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome, screen_size: [ 1400, 1400 ]

  include Warden::Test::Helpers

  def setup
    super
    Warden.test_mode!
  end

  def teardown
    super
    Warden.test_reset!
  end
end
