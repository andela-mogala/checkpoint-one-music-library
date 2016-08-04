class MusicLibraryController
  include Concerns::HelperMethods

  def initialize(path="./db/mp3s")
    @path = path
    @music_importer = MusicImporter.new(path)
    @music_importer.import
  end

  def call
    welcome_user
    user_choice = ""
    while user_choice != "exit"
      user_choice = get_user_input.downcase
      execute_user_choice(user_choice) if user_choice_is_valid?(user_choice)
      prompt_user
    end
  end

  private

  def execute_user_choice(option)
    case option
      when "list songs" then list_songs
      when "list artists" then list_artists
      when "list genres" then list_genres
      when "play song" then play_song
      when "list artist" then print_artist_name
      when "list genre" then print_genre
    end
  end

  def list_songs
    count = 0
    @music_importer.files.each do |file|
      count += 1
      print_out "#{count}. #{self.remove_mp3_extension(file)}"
    end
  end

  def list_artists
    @music_importer.files.each do |file|
      song = Song.create_from_filename(file)
      print_out song.artist.name
    end
  end

  def list_genres
    @music_importer.files.each do |file|
      song = Song.create_from_filename(file)
      print_out song.genre.name
    end
  end

  def play_song
    print_out "Enter the song number like '1' or '23'"
    song_num = get_user_input.to_i
    print_out "Playing " + self.remove_mp3_extension(@music_importer.files[song_num - 1])
  end

  def print_artist_name
    print_out "Enter the artist's name"
    prompt_user
    artist_name = get_user_input
    @music_importer.files.each do |file|
      print_out self.remove_mp3_extension(file) if file.include?(artist_name)
    end
  end

  def print_genre
    print_out "Enter the genre name"
    print_out ""
    genre_name = get_user_input
    @music_importer.files.each do |file|
      print_out self.remove_mp3_extension(file) if file.include?(genre_name)
    end
  end

  def welcome_user
    prompt = "Welcome.\nTo list all songs type \"list songs\"\n" +
             "To see a list of artists type \"list artists\"\n" +
             "To see alist of genres type \"list genres\"\n" +
             "To play a song type \"play song\"\n" +
             "To see a list of songs from an artist type \"list artist\"\n" +
             "To see a list of genres from an artist type \"list genre\"\n" +
             "Type exit to exit the program."
    print_out prompt
    prompt_user
  end

  def user_choice_is_valid?(user_choice)
    commands = ["list songs", "list artists", "list genres", "play song", "list artist", "list genre", "exit"]
    if commands.include?(user_choice)
      return true
    end
    print_out "You entered a wrong command"
    false
    end

    def prompt_user
      print "\nEnter a command>>"
    end
end
