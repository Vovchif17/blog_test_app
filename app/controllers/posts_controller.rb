class PostsController < ApplicationController
  before_action :set_post, only: %i[show edit update destroy]
  allow_unauthenticated_access only: %i[index show]

  def index
    @posts = Post.order(created_at: :desc)
  end

  def show
    @post = Post.find(params[:id])
    @comment = @post.comments.build
    @comments = @post.comments
  end
  
  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
  
    if @post.save
      respond_to do |format|
        format.html { redirect_to posts_path, notice: "Post created!" }
        format.turbo_stream { render turbo_stream: turbo_stream.append("posts", partial: "posts/post", locals: { post: @post }) }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      respond_to do |format|
        format.html { redirect_to @post, notice: "Post updated!" }
        format.turbo_stream
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_path, notice: "Post deleted!" }
      format.turbo_stream
    end
  end

  private

  def set_post
    @post = Post.find_by(id: params[:id])
    unless @post
      redirect_to posts_path, alert: "Post not found"
    end
  end

  def post_params
    params.require(:post).permit(:title, :body)
  end
end
