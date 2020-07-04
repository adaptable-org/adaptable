# frozen_string_literal: true

group :red_green_refactor, halt_on_fail: true, all_after_pass: true, all_on_start: true do
  guard :minitest, run_on_start: true, all_after_pass: true do
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

  guard :brakeman, run_on_start: true do
    watch(%r{^app/.+\.(erb|rb)$})
    watch(%r{^config/.+\.rb$})
    watch(%r{^lib/.+\.rb$})
    watch('Gemfile')
  end

  guard :rubocop, run_on_start: true do
    watch(/.+\.rb$/)
    watch(%r{(?:.+/)?\.rubocop(?:_todo)?\.yml$}) { |m| File.dirname(m[0]) }
  end
end
