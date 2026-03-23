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

  def render_site_shell(content_partial:, locals: {}, slider_partial: nil, slider_locals: {}, template_file: "index.html", inject_styles: true)
    template = File.read(Rails.public_path.join(template_file))
    content_markup = render_to_string(partial: content_partial, formats: [:html], locals: locals)
    sidebar_markup = render_to_string(partial: "shared/site_sidebar", formats: [:html], locals: locals)
    slider_markup = if slider_partial
      render_to_string(partial: slider_partial, formats: [:html], locals: slider_locals)
    end

    template.sub!("</head>", "#{site_shell_styles}</head>") if inject_styles

    if slider_markup.present?
      existing_slider_start = template.index('<div id="post_featured_slider"')
      existing_slider_end = template.index('<div id="page_content_wrapper">', existing_slider_start || 0)

      if existing_slider_start && existing_slider_end
        template = template[0...existing_slider_start] + slider_markup + "\n" + template[existing_slider_end..]
      else
        template.sub!('<div id="page_content_wrapper">', "#{slider_markup}\n<div id=\"page_content_wrapper\">")
      end
    end

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
      .site-sidebar-shell .sidebar_widget > li{margin-bottom:24px;}
      .site-sidebar-shell .posts.blog.withthumb li{display:flex;gap:12px;align-items:flex-start;}
      .site-sidebar-shell .posts.blog.withthumb li + li{margin-top:16px;}
      .site-sidebar-shell .post_circle_thumb img{width:78px;height:58px;object-fit:cover;}
      .site-sidebar-shell .post_attribute{display:block;margin-top:4px;font-size:12px;color:#999;}
      .site-sidebar-shell .simple-newsletter-form input[type=email]{width:100%;margin-bottom:10px;}
      .site-sidebar-shell .simple-newsletter-form input[type=submit]{width:100%;}
      .home-dynamic-featured .post_img.static img{width:960px !important;height:640px !important;object-fit:cover;}
      .home-dynamic-post .post_img.static.small img{width:700px !important;height:529px !important;object-fit:cover;}
      .home-dynamic-post .post_header_title,.home-dynamic-featured .post_header_title{min-height:118px;}
      .home-dynamic-post .post_header_title h5,.home-dynamic-featured .post_header_title h5{min-height:58px;}
      .home-dynamic-post .post_excerpt{min-height:68px;display:-webkit-box;-webkit-line-clamp:3;-webkit-box-orient:vertical;overflow:hidden;}
      .home-dynamic-featured .post_excerpt{min-height:78px;display:-webkit-box;-webkit-line-clamp:4;-webkit-box-orient:vertical;overflow:hidden;}
      .home-dynamic-post .post_info_cat a,.home-dynamic-featured .post_info_cat a,.single-dynamic-post .post_info_cat a{pointer-events:none;}
      .single-dynamic-post .post_img.static img{width:960px !important;height:640px !important;object-fit:cover;}
      .single-dynamic-post .post_header.single .post_header_title h1{font-size:34px;}
      .single-dynamic-post .post_excerpt{font-size:15px;line-height:1.8;}
      .single-dynamic-post .post_content_body{margin-top:24px;}
      .single-dynamic-post .post_content_body p{margin:0 0 18px;}
      </style>
    HTML
  end
end
