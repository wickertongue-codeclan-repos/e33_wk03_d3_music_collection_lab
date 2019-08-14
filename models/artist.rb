require('pry')

require_relative('./album')

class Artist

  attr_accessor :id, :name

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @name = options['name']
  end

  def save
    db = PG.connect({dbname: 'music_collection', host: 'localhost'})
    sql = "
    INSERT INTO artists
    (
      name
      )
    VALUES
    ($1)
    RETURNING id "
    values = [@name]
    db.prepare("save", sql)
    @id = db.exec_prepared("save", values)[0]["id"].to_i
    db.close()
  end

  def Artist.all
    db = PG.connect({dbname: 'music_collection', host: 'localhost'})
    sql = "
      SELECT * FROM artists"
    db.prepare("all", sql)
    result = db.exec_prepared("all")
    db.close()
    artist = result.map { |artist_hash| Artist.new(artist_hash) }
    return artist
  end

  def albums
    db = PG.connect({dbname: 'music_collection', host: 'localhost'})
    sql = "SELECT * FROM albums WHERE artist_id = $1"
    values = [@id]
    db.prepare("albums", sql)
    result = db.exec_prepared("albums", values)
    db.close()
    albums = result.map { |album_hash| Album.new(album_hash) }
    return albums
  end

end
