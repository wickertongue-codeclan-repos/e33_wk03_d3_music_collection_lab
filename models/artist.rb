require('pry')

require_relative('./album')

class Artist

  attr_reader :id, :name

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @name = options['name']
  end

  def save
    db = PG.connect({dbname: 'music_collection', host: 'localhost'})
    sql = "
    INSERT INTO artists
    (
      name,
      )
    VALUES
    ($1)
    RETURNING id "
    values = [@name]
    db.prepare('save', sql)
    @id = db.exec_prepared('save', values)[0]['id'].to_i
    db.close()
  end

end
