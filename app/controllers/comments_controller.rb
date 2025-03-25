class CommentsController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)

    if @comment.save
      respond_to do |format|
        format.html { redirect_to @post, notice: "Comment added!" }
        format.turbo_stream
      end
    else
      render "posts/show", status: :unprocessable_entity
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to @comment.post, notice: "Comment deleted!" }
      format.turbo_stream
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end
