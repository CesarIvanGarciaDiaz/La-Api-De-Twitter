class TwitterUser < ActiveRecord::Base
  # Remember to create a migration!
  #Un TwitterUser debe de tener muchos Tweets
  has_many :tweet
  validates :oauth_token ,:oauth_token_secret,uniqueness: true
end
