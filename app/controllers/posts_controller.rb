class PostsController < ApplicationController
  def show
    @post = Post.published.find_by!(slug: params[:id])
    render_site_shell(content_partial: "posts/show_content", locals: { post: @post })
  end
end
