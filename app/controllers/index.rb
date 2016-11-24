require 'twitter'

get '/' do
  erb :index
end

post '/twitter' do
  CLIENT.update(params[:text])
  @tweet=(params[:text])
  erb :tweet
end



get '/sign_in' do
  # El método `request_token` es uno de los helpers
  # Esto lleva al usuario a una página de twitter donde sera atentificado con sus credenciales
  redirect request_token.authorize_url(:oauth_callback => "http://#{host_and_port}/auth")
  # Cuando el usuario otorga sus credenciales es redirigido a la callback_url
  # Dentro de params twitter regresa un 'request_token' llamado 'oauth_verifier'
end

get '/auth' do
  # Volvemos a mandar a twitter el 'request_token' a cambio de un 'access_token'
  # Este 'access_token' lo utilizaremos para futuras comunicaciones.
  @access_token = request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])
  # Despues de utilizar el 'request token' ya podemos borrarlo, porque no vuelve a servir.
  session.delete(:request_token)


  username = @access_token.params['screen_name']
  session[:oauth_token] = @access_token.params['oauth_token']
  session[:oauth_token_secret] = @access_token.params['oauth_token_secret']
  TwitterUser.create(username: username, oauth_token: session[:oauth_token], oauth_token_secret: session[:oauth_token_secret])
  session[:username] = username

  # Aquí es donde deberás crear la cuenta del usuario y guardar usando el 'access_token' lo siguiente:
  # nombre, oauth_token y oauth_token_secret
  # No olvides crear su sesión
  redirect to "/fetch"
end

# Para el signout no olvides borrar el hash de session


get '/fetch' do
  username=  session[:username]
  redirect to("/#{username}")
end

get '/:username' do

  @user="@#{params[:username]}"

  @user_created = TwitterUser.find_or_create_by(username: @user)
  @tweets_temporal = Tweet.where(id_tweet: @user_created.id)

  if @tweets_temporal.empty?
    tweets_twitter=CLIENT.user_timeline(@user,result_type:"recent").take(10)
    tweets_twitter.each do |t|
      Tweet.create(id_tweet: @user_created.id, tweet: t.text)
    end
  end

  if Time.now - @tweets_temporal.last.created_at > 10
    tweets_twitter=CLIENT.user_timeline(@user,result_type:"recent").take(5)
    tweets_twitter.each do  |t|
      Tweet.create(id_tweet: @user_created.id, tweet: t.text)
    end
  end
  @tweets = Tweet.where(id_tweet: @user_created.id)
  erb :tweets
end
