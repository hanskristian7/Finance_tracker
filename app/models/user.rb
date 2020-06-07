class User < ApplicationRecord
  has_many :user_stocks
  has_many :stocks, through: :user_stocks

  has_many :friendships
  has_many :friend, through: :friendships

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  

  def stock_already_tracked?(ticker_symbol)
    stock = Stock.check_db(ticker_symbol)
    return false unless stock
    stocks.where(id: stock.id).exists? 
  end       

  def under_stock_limit?
    stocks.count<10
  end

  def can_track_stock?(ticker_symbol)
    under_stock_limit? && !stock_already_tracked?(ticker_symbol)
  end

  def full_name
    if first_name && last_name
      "#{first_name} #{last_name}"
    else
      "Annonymous"
    end
  end
 
  def self.search(param)
    param.strip!
    to_send_back = (first_name_matches(param) + last_name_matches(param) + email_matches(param)).uniq
    return nil unless to_send_back
    to_send_back
  end

  def self.first_name_matches(param)
    matches('first_name', param)
  end

  def self.last_name_matches(param)
    matches('last_name', param)
  end

  def self.email_matches(param)
    matches('email', param)
  end

  def self.matches(field_name, param)
    where("#{field_name} like ?", "%#{param}%")
  end

  def except_current_user(users)
    users.reject { |user| user.id == self.id }
  end

  def friends_with?(friend)
    self.friend.where(id: friend).exists?
  end
end

  # # check if the friend can be followed
  # # check if the friend already followed
  # def already_followed?(friend_id)
  #   #if not found on the friendship table it means the friend has not been followed
  #   friend.find_by(id: friend_id).present?
  # end

  # def can_follow?(friend_id)
  #   #can follow if the friend not found on the friendship table
  #   !already_followed?(friend_id)
  # end

