class PagesController < ApplicationController
  def home
    render file: Rails.public_path.join("home_template.html"), layout: false
  end
end
