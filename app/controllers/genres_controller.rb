class GenresController < Sinatra::Base
  set :views, Proc.new { File.join(root, "../views") }

  get '/genres' do
    @genres = Genre.all
    erb :'/genres/index'
  end

  ## NEW
  get '/genres/new' do
    erb :'genres/new'
  end

  post '/genres' do
    @genre = Genre.create(params)
  end

  get '/genres/:slug' do
    @genre = Genre.find_by_slug(params["slug"])
    erb :'/genres/show'
  end

end
