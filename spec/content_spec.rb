path = Rails.root.join('content/spec')
Dir.glob("#{path}/**/*_spec.rb") do |file|
  require file
end
