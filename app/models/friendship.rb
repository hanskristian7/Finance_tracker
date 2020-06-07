class Friendship < ApplicationRecord
  belongs_to :user

  # additional reference to the same table
  belongs_to :friend, class_name: 'User'
end
