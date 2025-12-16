# test/test_helper.rb
ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  # 运行所有测试
  parallelize(workers: :number_of_processors)

  # 设置所有测试的夹具
  fixtures :all

  # 添加更多辅助方法
end
