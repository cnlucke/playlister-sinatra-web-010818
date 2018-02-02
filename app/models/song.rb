class Song < ActiveRecord::Base
  belongs_to :artist
  has_many :song_genres
  has_many :genres, through: :song_genres

  def self.find_by_slug(slug)
    name = slug.split("-").join(" ")
    self.all.select { |s| s.name.downcase == name }.first
  end

  def slug
    self.name.split(" ").map(&:downcase).join("-")
  end

end
