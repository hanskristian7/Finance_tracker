class UsersController < ApplicationController
  def my_portfolio
    @tracked_stocks = current_user.stocks
  end

  def my_friends
    @friends = current_user.friend
  end

  def search
    if params[:friend].present?
      @friends = params[:friend]
      if @friends
        @friends = User.search(params[:friend])
        @friends = current_user.except_current_user(@friends)
        # @friends = current_user.except_current_user(@friends)
        if @friends
          respond_to do |format|
            format.js { render partial: 'users/result/friend' }
          end
        else
          respond_to do |format|
            flash.now[:alert] = "Couldn't find user"
            format.js { render partial: 'users/result/friend' }
          end
        end    
      else
        respond_to do |format|
          flash.now[:alert] = "Please enter a friend name or email to search"
          format.js { render partial: 'users/result/friend' }
        end
      end
    end
  end
end