module Admin
  class SessionsController < ApplicationController
    layout "admin"

    def new
      redirect_to admin_root_path, notice: "Zaten giris yaptin." if admin_logged_in?
    end

    def create
      if valid_admin_credentials?(params[:username], params[:password])
        session[:admin_logged_in] = true
        redirect_to admin_root_path, notice: "Admin paneline hos geldin."
      else
        flash.now[:alert] = "Kullanici adi veya sifre hatali."
        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      reset_session
      redirect_to admin_login_path, notice: "Cikis yapildi."
    end
  end
end
