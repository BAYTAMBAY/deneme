class PagesController < ApplicationController
  def home
    @posts = Post.published.limit(7)
    template = File.read(Rails.public_path.join("index.html"))
    template.sub!("</head>", "#{home_posts_styles}</head>")

    posts_markup = render_to_string(
      partial: "pages/home_posts",
      formats: [:html],
      locals: { posts: @posts }
    )

    start_marker = '<div class="sidebar_content two_cols mixed">'
    end_marker = '<div class="sidebar_wrapper">'
    start_index = template.index(start_marker)
    end_index = template.index(end_marker, start_index)

    if start_index && end_index
      replacement = <<~HTML
        <div class="sidebar_content two_cols mixed">
        #{posts_markup}
        			</div>

        		
      HTML

      template = template[0...start_index] + replacement + template[end_index..]
    end

    render html: template.html_safe, layout: false
  end

  private

  def home_posts_styles
    <<~HTML
      <style id="oneticketaway-home-posts">
      .home-dynamic-featured .post_img.static img{width:960px !important;height:640px !important;object-fit:cover;}
      .home-dynamic-post .post_img.static.small img{width:700px !important;height:529px !important;object-fit:cover;}
      .home-dynamic-post .post_header_title,
      .home-dynamic-featured .post_header_title{min-height:118px;}
      .home-dynamic-post .post_header_title h5,
      .home-dynamic-featured .post_header_title h5{min-height:58px;}
      .home-dynamic-post .post_excerpt{min-height:68px;display:-webkit-box;-webkit-line-clamp:3;-webkit-box-orient:vertical;overflow:hidden;}
      .home-dynamic-featured .post_excerpt{min-height:78px;display:-webkit-box;-webkit-line-clamp:4;-webkit-box-orient:vertical;overflow:hidden;}
      .home-dynamic-post .post_info_cat a,
      .home-dynamic-featured .post_info_cat a{pointer-events:none;}
      </style>
    HTML
  end
end
