# https://thoughtbot.com/blog/automatically-wait-for-ajax-with-capybara

module WaitForAjax
  def wait_for_ajax
    Timeout.timeout(Capybara.default_max_wait_time) do
      loop until finished_all_ajax_requests?
    end
  end

  def finished_all_ajax_requests?
    # See app/javascript/packs/ApiClient.js
    pending = page.evaluate_script('window.pendingApiCalls')
    pending.nil? || pending.zero?
  end
end

RSpec.configure do |config|
  config.include WaitForAjax, type: :feature
end
