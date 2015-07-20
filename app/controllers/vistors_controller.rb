class VistorsController < ApplicationController
  before_filter :redirect_if_logged_in

  def redirect_if_logged_in
    if user_signed_in?
      redirect_to iterations_path
      return false
    end
  end

end
