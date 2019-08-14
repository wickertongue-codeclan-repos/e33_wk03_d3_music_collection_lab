require('pry')
require('pg')

require_relative('./artist')


class Album

  attr_reader :id, :title

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
      artist_id,
      )
    VALUES
    ($1, $2, $3)
    RETURNING * "
    values = [@title, @genre, @artist_id]
    db.prepare('save', sql)
    db.exec_prepared('save', values)
    db.close()
  end

end
