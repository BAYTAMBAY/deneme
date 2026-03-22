class ApplicationController < ActionController::Base
  helper_method :admin_logged_in?

  private

  def admin_logged_in?
    session[:admin_logged_in] == true
  end

  def require_admin_login
    return if admin_logged_in?

    redirect_to admin_login_path, alert: "Admin paneline girmek icin giris yapman gerekiyor."
  end

  def admin_username
    ENV.fetch("ADMIN_USERNAME", "admin")
  end

  def admin_password
    ENV.fetch("ADMIN_PASSWORD", "oneticketaway-admin")
  end

  def valid_admin_credentials?(username, password)
    secure_match?(username, admin_username) && secure_match?(password, admin_password)
  end

  def secure_match?(provided, expected)
    provided_digest = Digest::SHA256.hexdigest(provided.to_s)
    expected_digest = Digest::SHA256.hexdigest(expected.to_s)

    ActiveSupport::SecurityUtils.secure_compare(provided_digest, expected_digest)
  end
end
