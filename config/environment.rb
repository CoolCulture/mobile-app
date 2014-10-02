# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
MobileApp::Application.initialize!

Jbuilder.key_format camelize: :lower
