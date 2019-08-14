require_relative('./artist')

class Album

  attr_accessor :title, :genre
  attr_reader :id, :artist_id

  def initialize(options)
    @artist_id = options['artist_id'].to_i
    @id = options['id'].to_i if options['id']
    @title = options['title']
    @genre = options['genre']
  end

  def save
    sql = "
      INSERT INTO albums
      (
        artist_id,
        title,
        genre
        )
      VALUES
      ($1, $2, $3)
      RETURNING id "
    values = [@artist_id, @title, @genre]
    result = SqlRunner.run(sql, values)
    @id = result[0]["id"].to_i
  end

  def Album.all
    sql = "SELECT * FROM albums"
    result = SqlRunner.run(sql)
    album = result.map { |album_hash| Album.new(album_hash) }
    return album
  end

  def artist
    sql = "SELECT * FROM artists WHERE id = $1"
    values = [@artist_id]
    result = SqlRunner.run(sql, values)
    artist = result.map { |artist_hash| Artist.new(artist_hash) }
    return artist
  end

  def delete
    sql = "DELETE FROM albums WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def update
    sql = "
      UPDATE albums
      SET (
        artist_id,
        title,
        genre
      ) =
      ($1, $2, $3)
      WHERE id = $4"
    values = [@artist_id, @title, @genre, @id]
    SqlRunner.run(sql, values)
  end

  def Album.delete_all
    sql = "DELETE FROM albums"
    SqlRunner.run(sql)
  end

end
