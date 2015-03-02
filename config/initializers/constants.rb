BASE_URL =  if Rails.env.development?
              "http://localhost:3000/"
            elsif Rails.env.staging?
              "http://cooler-culture.herokuapp.com/"
            elsif Rails.env.production?
              "http://coolcultureapp.org/"
            end

EXPIRATION_DATE = Date.new(2015, 10, 31)

MINIMUM_PASS_ID = 10_000