class FriendshipsController < ApplicationController
    def create
        friend = User.find(params[:friend])

        Friendship.create(user_id: current_user.id, friend_id: friend.id) 
        flash[:notice] = "#{friend.email} was successfully added to friend list!"
        
        redirect_to my_friends_path
    end
    
    def destroy
        friend = User.find(params[:id])
        user_friend = Friendship.where(user_id: current_user.id, friend_id: friend.id).first
        user_friend.destroy
        flash[:notice] = "#{friend.email} was successfully removed!"
        redirect_to my_friends_path
    end    
end