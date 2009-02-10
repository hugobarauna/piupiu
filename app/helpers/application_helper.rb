# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def show_flash_messages
    if flash[:error]
      "<p style=\"color: red\">#{flash[:error]}</p>"
    elsif flash[:notice]
      "<p style=\"color: green\">#{flash[:notice]}</p>" 
    end
  end

end
