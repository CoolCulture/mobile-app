module BooleanHelper
	def human_to_boolean(input)
    if input.downcase == "yes"
      return true
    elsif input.downcase == "no"
      return false
    else
      input
    end
  end
end