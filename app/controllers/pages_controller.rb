class PagesController < ApplicationController
  def home
    posts = Post.published.limit(7)

    render_site_shell(
      content_partial: "pages/home_posts",
      locals: { posts: posts },
      slider_partial: "pages/home_slider",
      slider_locals: { posts: posts.first(3) },
      template_file: "home_template.html"
    )
  end
end
