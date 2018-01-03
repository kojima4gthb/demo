class CommentsController < ApplicationController
  before_action :set_comment, only: [:destroy, :approve]

  # POST /comments
  def create
    return unless correct_routes?(%w(entries show))

    comment = Comment.new(comment_params)
    respond_to do |format|
      if comment.save
        format.html {
          send_mail(:notice, comment, blog_entry_url(comment.entry.blog, comment.entry, host: request.host))
          redirect_to blog_entry_path(comment.entry.blog, comment.entry), notice: 'Comment was successfully created.'
        }
      else
        format.html { redirect_to blog_entry_path(comment.entry.blog, comment.entry), notice: comment.errors.full_messages[0] }
      end
    end
  end

  # DELETE /comments/1
  def destroy
    return unless correct_routes?(%w(entries show))

    @comment.destroy
    respond_to do |format|
      format.html { redirect_to blog_entry_path(@comment.entry.blog, @comment.entry), notice: 'Comment was successfully destroyed.' }
    end
  end

  def approve
    return unless correct_routes?(%w(entries show))

    @comment.status = 'approved'
    respond_to do |format|
      if @comment.save
        format.html { redirect_to blog_entry_path(@comment.entry.blog, @comment.entry), notice: 'Comment was successfully approved.' }
      else
        format.html { redirect_to blog_entry_path(@comment.entry.blog, @comment.entry), notice: @comment.errors.full_messages[0] }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:body, :status, :entry_id)
    end
end
