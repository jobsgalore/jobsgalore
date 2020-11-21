require 'test_helper'
require 'rails/performance_test_help'

class HomepageTest < ActionDispatch::PerformanceTest
  # Refer to the documentation for all available options
  self.profile_options = {
      runs: 5,
      metrics: [:wall_time, :memory],
      output: 'tmp/performance',
      formats: [:flat]
  }

  test "homepage" do
    get '/'
  end

  test "about us" do
    get '/about'
  end

  test "search_job" do
    get '/search?main_search[value]=&main_search[open]=false&main_search[type]=2&main_search[location_name]=Australia&main_search[location_id]='
  end

  test "search_resume" do
    get '/search?main_search[value]=&main_search[open]=false&main_search[type]=3&main_search[location_name]=Australia&main_search[location_id]='
  end

  test "search_company" do
    get '/search?main_search[value]=&main_search[open]=false&main_search[type]=1&main_search[location_name]=Australia&main_search[location_id]='
  end
end
