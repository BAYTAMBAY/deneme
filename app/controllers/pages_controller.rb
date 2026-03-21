class PagesController < ApplicationController
  def home
    render file: Rails.public_path.join("index.html"), layout: false
  end
end
