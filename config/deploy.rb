require 'capistrano/ext/multistage'

set :stages, %w(development staging production)
set :default_stage, 'development'
