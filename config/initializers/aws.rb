AWS.config( access_key_id:     ENV['AWSKEY'],
            secret_access_key: ENV['AWSSEC'] )

S3_CLIENT = AWS::S3::Client.new

PRODUCTION = ["production", "staging"].include?(Rails.env)

if PRODUCTION
  S3_BUCKET = 'coolculture-imports'
else
  S3_BUCKET = 'coolculture-import-test'
end