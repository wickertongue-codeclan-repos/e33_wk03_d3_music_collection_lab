require('pry')
require('pg')

require_relative('./artist')

class Album

  attr_accessor :id, :title

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @title = options['title']
    @genre = options['genre']
    @artist_id = options['artist_id'].to_i
  end

  def save
    db = PG.connect({dbname: 'music_collection', host: 'localhost'})
    sql = "
      INSERT INTO albums
      (
        title,
        genre,
        artist_id
        )
      VALUES
      ($1, $2, $3)
      RETURNING * "
    values = [@title, @genre, @artist_id]
    db.prepare("save", sql)
    db.exec_prepared("save", values)
    db.close()
  end

  def Album.all
    db = PG.connect({dbname: 'music_collection', host: 'localhost'})
    sql = "
      SELECT * FROM albums"
    db.prepare("all", sql)
    result = db.exec_prepared("all")
    db.close()
    album = result.map { |album_hash| Album.new(album_hash) }
    return album
  end

  def artist
    db = PG.connect({dbname: 'music_collection', host: 'localhost'})
    sql = "SELECT * FROM artists WHERE id = $1"
    values = [@artist_id]
    db.prepare("artist", sql)
    result = db.exec_prepared("artist", values)
    db.close()
    artist = result.map { |artist_hash| Artist.new(artist_hash) }
    return artist
  end

end
