require 'rubygems'
require "sinatra/base"
require 'json'
require 'sequel'

require '../lib/line_man_base'
require '../lib/line_man_queue'
require '../lib/line_man_queue_element'
require '../lib/line_man_repository'


class NowServingWeb < Sinatra::Base

  configure do

  	db = Sequel.connect('jdbc:sqlite:../db/bar2.db')

  	repo = LineManRepository.new(db)

  	set :repo, repo

  end

  get '/' do
    "Hello"
  end

  get '/queue/:id' do

  	q = settings.repo.get_queue(params['id'])

  	content_type :json

  	JSON.pretty_generate(q.to_hash)

  end

  post '/queue/:id/create_next_queue_element' do

  	q = settings.repo.get_queue(params['id'])
  	e = q.create_next_queue_element('me')

  	content_type :json

  	JSON.pretty_generate(e.to_hash)

  end

  post '/queue/:id/advance' do

  	q = settings.repo.get_queue(params['id'])
  	e = q.advance

  	content_type :json

  	JSON.pretty_generate(e.to_hash)

  end

  post '/queue/create' do

  	request.body.rewind
  	payload = JSON.parse(request.body.read)

  	id = payload['id']
  	owner = payload['owner']

  	q = settings.repo.create_queue(id, owner)

  	content_type :json

  	JSON.pretty_generate(q.to_hash)

  end
  
end