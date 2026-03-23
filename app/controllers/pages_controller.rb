class PagesController < ApplicationController
  def home
    @posts = Post.published.limit(7)
    render_site_shell(content_partial: "pages/home_posts", locals: { posts: @posts })
  end
end
