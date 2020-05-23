class CommentsController < ApplicationController
    before_action :logged_in_user

    def create
        @comment = @commentable.comments.new comment_params
        @comment.save
        flash[:success] = "Your comment was successfully created"
        redirect_to @commentable
    end

    private

        def comment_params
            params.require(:comment).permit(:body)
        end
end