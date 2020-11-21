# frozen_string_literal: true

if ENV["COVERAGE"]
  SimpleCov.start 'rails' do
    add_group "Concerns", ["app/models/concerns", "app/controllers/concerns"]

    enable_coverage :branch # See: https://github.com/colszowka/simplecov#branch-coverage-ruby--25

    minimum_coverage line: 90, branch: 90
    refuse_coverage_drop
  end
end
