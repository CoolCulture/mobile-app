BASE_URL =  if Rails.env.development?
              "http://localhost:3000/"
            elsif Rails.env.staging?
              "http://cooler-culture.herokuapp.com/"
            elsif Rails.env.production?
              "http://coolcultureapp.org/"
            end

EXPIRATION_DATE = Date.new(2015, 10, 31)

MINIMUM_PASS_ID = 10_000

ADMIN_EMAIL =  Rails.env.production? ? "app@coolculture.org" : "app+local@coolculture.org"

DEFAULT_IMAGE = "https://s3-us-west-2.amazonaws.com/app-photos/CC_logo"

SUBWAY_LINES = [
  "1", "2", "3", "4", "5", "6", "7", "A", "C", "E", "B", "D", "F", "M",
  "G", "J", "Z", "L", "S", "N", "Q", "R", "SIR"
]

CATEGORIES = [
  "History", "Science", "Art", "Nature", "Other", "Featured"
]

BOROUGHS = {"M" => "Manhattan",
            "BX" => "Bronx",
            "BK" => "Brooklyn",
            "SI" => "Staten Island",
            "Q" => "Queens"}