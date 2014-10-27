BASE_URL =  if Rails.env.development?
              "http://localhost:3000/"
            elsif Rails.env.staging?
              "http://cooler-culture.heroku.com/"
            elsif Rails.env.production?
              "http://coolculture.com/"
            end

EXPIRATION_DATE = Date.new(2015, 10, 31)