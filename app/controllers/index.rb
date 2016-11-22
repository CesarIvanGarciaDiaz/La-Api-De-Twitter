require 'twitter'

get '/' do
  erb :index
end

post '/twitter' do
  CLIENT.update(params[:text])
@tweet=(params[:text])
erb :tweet
end

post '/fetch' do
  username = params[:twitter_handle]
  redirect to("/#{username}")
end

get '/:username' do

  @user = params[:username]
  @user_created = TwitterUser.find_or_create_by(username: @user)
  tweets = Tweet.where(id_tweet: @user_created.id)

  if tweets.empty?
    tweets_twitter=CLIENT.user_timeline(@user,result_type:"recent").take(10)
    tweets_twitter.each do |t|
      Tweet.create(id_tweet: @user_created.id, tweet: t.text)
    end
  end

  if Time.now - tweets.last.created_at > 10
    tweets_twitter=CLIENT.user_timeline(@user,result_type:"recent").take(5)
    tweets_twitter.each do  |t|
      Tweet.create(id_tweet: @user_created.id, tweet: t.text)
    end
  end
  @tweets = Tweet.where(id_tweet: @user_created.id)

  erb :tweets
end
