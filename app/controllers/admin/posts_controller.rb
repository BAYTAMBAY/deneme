module Admin
  class PostsController < BaseController
    before_action :set_post, only: [:show, :edit, :update, :destroy]

    def index
      @posts = Post.order(created_at: :desc)
    end

    def show
    end

    def new
      @post = Post.new(status: "draft")
    end

    def create
      @post = Post.new(post_params)

      if @post.save
        redirect_to admin_post_path(@post), notice: "Yazi olusturuldu."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @post.update(post_params)
        redirect_to admin_post_path(@post), notice: "Yazi guncellendi."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @post.destroy
      redirect_to admin_root_path, notice: "Yazi silindi."
    end

    private

    def set_post
      @post = Post.find_by!(slug: params[:id])
    end

    def post_params
      params.require(:post).permit(
        :title,
        :slug,
        :excerpt,
        :body,
        :cover_image_url,
        :status,
        :published_at,
        :meta_title,
        :meta_description
      )
    end
  end
end
