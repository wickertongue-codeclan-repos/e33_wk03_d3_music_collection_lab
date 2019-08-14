require('pry')

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

  end

end
