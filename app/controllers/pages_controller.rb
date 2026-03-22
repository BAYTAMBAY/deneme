class PagesController < ApplicationController
  def home
    @posts = Post.published.limit(7)
    template = File.read(Rails.public_path.join("index.html"))

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
end
