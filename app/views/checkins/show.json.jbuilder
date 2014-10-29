json.extract! @checkin, :slug, :number_of_adults, :number_of_children,
                        :date, :family_card_id, :last_name

json.museum do
  json.name @checkin.museum.name
  json.twitter @checkin.museum.twitter
  json.facebook @checkin.museum.facebook
end
