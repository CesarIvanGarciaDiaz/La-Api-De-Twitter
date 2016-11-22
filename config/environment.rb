# Hace require de los gems necesarios.
# Revisa: http://gembundler.com/bundler_setup.html
#      http://stackoverflow.com/questions/7243486/why-do-you-need-require-bundler-setup
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])

# Require gems we care about
require 'rubygems'
require 'uri'
require 'pathname'
require 'pg'
require 'active_record'
require 'logger'
require 'sinatra'
require "sinatra/reloader" if development?
require 'erb'
#agregamos un require de la api twitter
require 'twitter'

APP_ROOT = Pathname.new(File.expand_path('../../', __FILE__))

APP_NAME = APP_ROOT.basename.to_s

# Configura los controllers y los helpers
Dir[APP_ROOT.join('app', 'controllers', '*.rb')].each { |file| require file }
Dir[APP_ROOT.join('app', 'helpers', '*.rb')].each { |file| require file }
Dir[APP_ROOT.join('app', 'uploaders', '*.rb')].each { |file| require file }

# Configura la base de datos y modelos
require APP_ROOT.join('config', 'database')


#configuracion de twitter
CLIENT = Twitter::REST::Client.new do |config|
 config.consumer_key        = "L1kwLZMcn6WFhjbYNlRiA1Ijq"
 config.consumer_secret     = "rJtV5vmqbXWRmADT9o3uwgCOuQO5jWkK6MPX860xVWIBgbkHgb"
 config.access_token        = "346822815-YCg62fPY4EX6VUPbOs2M9QxfV7MiG7ycz44HvUS2"
 config.access_token_secret = "DdYBlgrEqjHMsFuLZQYZqoiB9YR4drzEskfOTIOM6YAIq"
end
