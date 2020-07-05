SimpleCov.start 'rails' do
  enable_coverage :branch # See: https://github.com/colszowka/simplecov#branch-coverage-ruby--25

  minimum_coverage line: 90, branch: 90
  refuse_coverage_drop
end
Rails.application.eager_load!
