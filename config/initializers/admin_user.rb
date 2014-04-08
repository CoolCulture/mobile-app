unless Rails.env.production?
  ENV['ADMIN_USER'] = 'cool'
  ENV['ADMIN_PASS'] = 'test'
end

ADMIN_USER = ENV['ADMIN_USER']
ADMIN_PASS = ENV['ADMIN_PASS']
