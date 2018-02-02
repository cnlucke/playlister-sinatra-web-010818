class SongsController < Sinatra::Base
  set :views, Proc.new { File.join(root, "../views") }

  get '/songs' do
    @songs = Song.all
    erb :'/songs/index'
  end

  ## NEW
  get '/songs/new' do
    @genres = Genre.all
    @artists = Artist.all

    erb :'songs/new'
  end

  post '/songs' do
    @song = Song.create(name: params["song"]["name"])

    #This prioritizes a new artist specified over a checked existing artist
    if !params["artist"].nil? #new artist specified
      @artist = Artist.find_or_create_by(name: params["artist"])
      @artist.songs << @song
    elsif !params["song"]["artist"].nil? #existing artist specified
      @artist = Artist.find_or_create_by(name: params["song"]["artist"])
      @artist.songs << @song
    else
       #no artist specified should throw error, but don't know how to do that yet
    end

    #Turn genre ids array into genre object array
    @genre_ids = params["song"]["genres"]
    @genres = @genre_ids.map { |g| Genre.find(g.to_i)}
    #Create SongGenre for song and each genre to associate them
    sg = SongGenre.new
    @genres.each do |g|
      g.song_genres << sg
      @song.song_genres << sg
    end

    @songs = Song.all

    redirect to :"songs/#{@song.slug}"
  end

  #UPDATE
  get '/songs/:slug/edit' do
    @song = Song.all.find_by_slug(params["slug"])
    @genres = Genre.all
    erb :'/songs/edit'
  end

  patch '/songs/:slug' do
    @song = Song.all.find_by_slug(params["slug"])
    @song.update(name: params["song"]["name"])

    @artist = Artist.find_or_create_by(name: params["song"]["artist"])
    @artist.songs << @song

    #Turn genre ids array into genre object array
    @genre_ids = params["song"]["genres"]
    @genres = @genre_ids.map { |g| Genre.find(g.to_i)}

    #Remove old SongGenre rows
    song_genres = SongGenre.all.select { |sg| sg.song == @song }
    song_genres.each { |sg| sg.destroy }

    #Create SongGenre for song and each genre to associate them
    @genres.each do |g|
      sg = SongGenre.new
      g.song_genres << sg
      @song.song_genres << sg
    end

    redirect to "/songs/#{@song.slug}"
  end

  # Show single song
  get '/songs/:slug' do
    @song = Song.find_by_slug(params["slug"])
    @genres = Genre.all
    @artists = Artist.all
    erb :'/songs/show'
  end

end
