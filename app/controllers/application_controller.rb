class ApplicationController < ActionController::Base
  before_filter :deep_snake_case_params!

  def deep_snake_case_params!(val = params)
    case val
    when Array
      val.map {|v| deep_snake_case_params! v }
    when Hash
      val.keys.each do |k, v = val[k]|
        val.delete k
        val[k.underscore] = deep_snake_case_params!(v)
      end
      val
    else
      val
    end
  end

  def is_admin?
    unless current_user.try(:admin?)
      redirect_to("#/login") 
    end
  end

  respond_to :html, :json
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery
end
