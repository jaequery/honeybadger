directories %w(app config lib models spec)
guard :rspec, cmd: 'rspec --color' do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch(%r{^app/(.+)\.rb$})     { |m| "spec/app/#{m[1]}_spec.rb" }
  watch(%r{^models/(.+)\.rb$})     { |m| "spec/models/#{m[1]}_spec.rb" }
  watch(%r{^config/(.+)\.rb$})     { |m| "spec" }
  watch('spec/spec_helper.rb')  { "spec" }
end
