class ArtistsController < Sinatra::Base
  set :views, Proc.new { File.join(root, "../views") }

  get '/artists' do
    @artists = Artist.all
    erb :'/artists/index'
  end

  ## NEW
  get '/artists/new' do
    erb :'artists/new'
  end

  post '/artists' do
    @artist = Artist.create(params)
  end

  get '/artists/:slug' do
    @artist = Artist.find_by_slug(params[:slug])
    erb :'/artists/show'
  end

end
