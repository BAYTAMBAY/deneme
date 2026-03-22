module Admin
  class BaseController < ApplicationController
    layout "admin"
    before_action :require_admin_login
  end
end
