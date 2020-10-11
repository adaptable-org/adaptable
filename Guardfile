# frozen_string_literal: true

group :bundler, halt_on_fail: true, all_on_start: true do
  # Before testing gets going, let's make sure no gems need updating
  guard :bundler do
    watch('Gemfile')
  end

  # Before testing gets going, let's make sure no gems are security risks
  guard :bundler_audit do
    watch('Gemfile.lock')
  end

  guard :shell do
    watch(%r{^package.json$})      { `yarn audit --level moderate` }
    watch(%r{^yarnfile.lock$})     { `yarn audit --level moderate` }
  end
end

group :code, halt_on_fail: true, all_after_pass: true, all_on_start: true do
  # Tests first and foremost. If they're not passing, nothing else matters.
  guard :minitest do
    # Rails and Minitest
    watch(%r{^app/(.+)\.rb$})                               { |m| "test/#{m[1]}_test.rb" }
    watch(%r{^app/controllers/application_controller\.rb$}) { 'test/controllers' }
    watch(%r{^app/controllers/(.+)_controller\.rb$})        { |m| "test/integration/#{m[1]}_test.rb" }
    watch(%r{^app/views/(.+)_mailer/.+})                    { |m| "test/mailers/#{m[1]}_mailer_test.rb" }
    watch(%r{^lib/(.+)\.rb$})                               { |m| "test/lib/#{m[1]}_test.rb" }
    watch(%r{^test/.+_test\.rb$})
    watch(%r{^test/fixtures/(.+)\.yml$}) { 'test' }
    watch(%r{^test/support/(.+)\.rb$}) { 'test' }
    watch(%r{^test/test_helper\.rb$}) { 'test' }
  end

  # If the tests pass, check for potential security issues.
  guard :brakeman do
    watch(%r{^app/.+\.(erb|rb)$})
    watch(%r{^config/.+\.rb$})
    watch(%r{^lib/.+\.rb$})
    watch('Gemfile')
  end

  # The code's in good shape, so check for cleanup work.
  guard :rubocop do
    watch(/.+\.rb$/)
    watch(/config\/.+\.rb$/)
    watch(%r{(?:.+/)?\.rubocop(?:_todo)?\.yml$}) { |m| File.dirname(m[0]) }
  end
end
