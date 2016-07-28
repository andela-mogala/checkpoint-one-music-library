class Song
  extend Concerns::Findable

  attr_accessor :name
  attr_reader :artist, :genre
  @@all = []

  def initialize(name, artist = nil, genre = nil)
    @name = name
    self.artist = artist if artist.is_a? Artist
    self.genre = genre if genre.is_a? Genre
    self.artist.add_genre(genre) unless genre == nil
    genre.artists = artist if genre != nil and artist != nil
  end

  def Song.all
    @@all
  end

  def Song.destroy_all
    @@all = []
  end

  def save
    @@all << self
  end

  def Song.create(name)
    song = Song.new(name)
    Song.all << song
    song
  end

  def artist=(artist)
    artist.add_song(self) if !artist.songs.include?(self)
    #artist.songs << self if !artist.songs.include?(self)
    @artist ||= artist
  end

  def setArtist(artist)
    @artist = artist
  end

  def genre=(genre)
    genre.songs << self unless genre.songs.include?(self)
    @genre = genre
  end

end
