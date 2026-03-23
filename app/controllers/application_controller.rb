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

  def render_site_shell(content_partial:, locals: {})
    template = File.read(Rails.public_path.join("index.html"))
    content_markup = render_to_string(partial: content_partial, formats: [:html], locals: locals)
    sidebar_markup = render_to_string(partial: "shared/site_sidebar", formats: [:html], locals: locals)

    template.sub!("</head>", "#{site_shell_styles}</head>")

    start_marker = '<div class="inner_wrapper">'
    end_marker = '<!-- End main content -->'
    start_index = template.index(start_marker)
    end_index = template.index(end_marker, start_index)

    if start_index && end_index
      replacement = <<~HTML
        <div class="inner_wrapper">
        			#{content_markup}

        			#{sidebar_markup}

        	</div>
      HTML

      template = template[0...start_index] + replacement + template[end_index..]
    end

    render html: template.html_safe, layout: false
  end

  def site_shell_styles
    <<~HTML
      <style id="oneticketaway-site-shell">
      #page_content_wrapper .inner .sidebar_wrapper.site-sidebar-shell{display:block !important;background:#f2f2f2;}
      .site-sidebar-shell .sidebar_widget{margin:0;padding:0;list-style:none;}
      .site-sidebar-shell .sidebar_widget > li{margin:0 0 26px;}
      .site-sidebar-shell .textwidget p{margin:0 0 14px;}
      .site-sidebar-shell .widget-card{background:#fff;border:1px solid #e8dfd2;border-radius:4px;padding:22px;box-shadow:0 12px 30px rgba(34,34,34,.06);}
      .site-sidebar-shell .widget-card h3,
      .site-sidebar-shell .widget-card h2{margin:0 0 12px;font-family:"Josefin Sans", Helvetica, Arial, sans-serif;font-size:12px;letter-spacing:2px;text-transform:uppercase;}
      .site-sidebar-shell .widget-card .button{display:inline-block;margin-top:10px;}
      .site-sidebar-shell .sidebar-list{margin:0;padding:0;list-style:none;}
      .site-sidebar-shell .sidebar-list li{padding:12px 0;border-bottom:1px solid #ece4d9;}
      .site-sidebar-shell .sidebar-list li:last-child{border-bottom:0;padding-bottom:0;}
      .site-sidebar-shell .sidebar-list a{display:block;font-weight:700;}
      .site-sidebar-shell .sidebar-list span{display:block;color:#8c7d6d;font-size:12px;margin-top:4px;}
      .site-sidebar-shell .sidebar-cta{background:#fff7ec;border:1px solid #edd9b8;}
      .home-dynamic-featured .post_img.static img{width:960px !important;height:640px !important;object-fit:cover;}
      .home-dynamic-post .post_img.static.small img{width:700px !important;height:529px !important;object-fit:cover;}
      .home-dynamic-post .post_header_title,.home-dynamic-featured .post_header_title{min-height:118px;}
      .home-dynamic-post .post_header_title h5,.home-dynamic-featured .post_header_title h5{min-height:58px;}
      .home-dynamic-post .post_excerpt{min-height:68px;display:-webkit-box;-webkit-line-clamp:3;-webkit-box-orient:vertical;overflow:hidden;}
      .home-dynamic-featured .post_excerpt{min-height:78px;display:-webkit-box;-webkit-line-clamp:4;-webkit-box-orient:vertical;overflow:hidden;}
      .home-dynamic-post .post_info_cat a,.home-dynamic-featured .post_info_cat a,.single-dynamic-post .post_info_cat a{pointer-events:none;}
      .single-dynamic-post .post_img.static img{width:960px !important;height:640px !important;object-fit:cover;}
      .single-dynamic-post .post_excerpt{font-size:15px;line-height:1.8;}
      .single-dynamic-post .post_content_body{margin-top:24px;}
      .single-dynamic-post .post_content_body p{margin:0 0 18px;}
      </style>
    HTML
  end
end
