class Artist < ActiveRecord::Base
  has_many :songs
  has_many :genres, through: :song_genres

  def genres #returns array of genre objects
    genres = []
    self.songs.each do |s|
      genres = genres + s.genres
    end
    genres.uniq
  end

  def self.find_by_slug(slug)
    name = slug.split("-").join(" ")
    self.all.select { |s| s.name.downcase == name }.first
  end

  def slug
    self.name.split(" ").map(&:downcase).join("-")
  end

end
