class Genre < ActiveRecord::Base
  has_many :artists
  has_many :song_genres
  has_many :songs, through: :song_genres

  def self.find_by_slug(slug)
    name = slug.split("-").join(" ")
    self.all.select { |s| s.name.downcase == name }.first
  end

  def slug
    self.name.split(" ").map(&:downcase).join("-")
  end

  def artists #Returns array of artist objects
    artists = []
    songs = self.songs
    songs.each do |s|
      artists << s.artist
    end
    artists
  end
end
