# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard :rspec do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/actionmodel/(.+)\.rb$})     { |m| "spec/#{m[1]}_spec.rb" }
  watch('lib/actionmodel.rb')  { 'spec' }
  watch('spec/spec_helper.rb')  { 'spec' }
end

