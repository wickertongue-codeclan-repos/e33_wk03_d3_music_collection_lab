require('pry')

require_relative('./album')
require_relative('../db/sql_runner')

class Artist

  attr_accessor :name
  attr_reader :id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @name = options['name']
  end

  def save
    sql = "
    INSERT INTO artists
    (
      name
      )
    VALUES
    ($1)
    RETURNING id "
    values = [@name]
    result = SqlRunner.run(sql, values)
    @id = result[0]["id"].to_i
  end

  def Artist.all
    sql = "SELECT * FROM artists"
    result = SqlRunner.run(sql)
    artist = result.map { |artist_hash| Artist.new(artist_hash) }
    return artist
  end

  def Artist.delete_all
    sql = "DELETE FROM artists"
    SqlRunner.run(sql)
  end

  def albums
    sql = "SELECT * FROM albums WHERE artist_id = $1"
    values = [@id]
    result = SqlRunner.run(sql, values)
    albums = result.map { |album_hash| Album.new(album_hash) }
    return albums
  end

  def delete
    sql = "DELETE FROM artists WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def update
    sql = "UPDATE artists SET name = $1 WHERE id = $2"
    values = [@name, @id]
    SqlRunner.run(sql, values)
  end

  def Artist.find_by_id(id)
    sql = "SELECT * FROM artists WHERE id = $1"
    values = [id]
    result = SqlRunner.run(sql, values)
    return nil if result.first() == nil
    artist_hash = result[0]
    found_artist = Artist.new(artist_hash)
    return found_artist
  end


end
