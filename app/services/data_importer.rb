require 'oj'

class DataImporter < ::Oj::Saj
  def initialize
    super
    @saved = 0
    @current_movie = nil
    @array = nil
    @actors = []
  end

  def run!(filename)
    # Disable index during json import
    Movie.without_auto_index do
      File.open(filename, 'r') do |file|
        Oj.saj_parse(self, file)
      end
    end
    puts '* reindexing'
    Movie.reindex!
  end

  # OJ callback: parsing new object (movie)
  def hash_start(_key)
    @current_movie = {
      title: nil,
      year: nil,
      image: nil,
      color: nil,
      score: nil,
      rating: nil,
      alternative_titles: [],
      genres: [],
    }
    @array_name = nil
  end

  # OJ callback: end of object (movie)
  def hash_end(_key)
    save_batch
  end

  # OJ callback: parsing new array
  # Save key to keep track of array (genres, actors, ...)
  def array_start(key)
    @array_name = key
  end

  # OJ callback: parsing scalar value
  def add_value(value, key)
    if key
      # Key is present: parsing key-value pair of Movie object
      case key
      when 'title', 'year', 'image', 'color', 'score', 'rating'
        @current_movie[key] = value
      end
    else
      # Key is missing: parsing array element
      case @array_name
      when 'alternative_titles'
        @current_movie[:alternative_titles] << value
      when 'genre'
        @current_movie[:genres] << value
      when 'actors'
        @actors << {
          name: value,
          created_at: Time.now.utc,
          updated_at: Time.now.utc,
        }
      when 'actor_facets'
        # value is "https://url|Actor Name"
        url, name = value.split('|')
        # Update associated actor in @actors array
        @actors.find { |obj| obj[:name] == name }[:image] = url
      end
    end
  end

  private

  def save_batch
    movie = Movie.create!(@current_movie)
    # Some movies contain the same actor twice!
    # This is not supported by UPSERT
    # See: https://pganalyze.com/docs/log-insights/app-errors/U126
    @actors.uniq! { |hash| hash[:name] }

    if @actors.any?
      actor_ids = Actor
        .upsert_all(@actors, unique_by: :index_actors_on_name)
        .pluck('id')
      @actors = []

      # Bypass ActiveRecord to insert into actors_movies with a single
      # insert statement
      # Using movie.update!(actor_id) would trigger 1 sql query per movie
      values = actor_ids.map { |id| "(#{id}, #{movie.id})" }.join(', ')
      Movie.connection.execute("
        INSERT INTO actors_movies (actor_id, movie_id) VALUES #{values}
      ")
    end

    @saved += 1
  end

  def error(message, line, column)
    puts "ERROR: #{line}:#{column}: #{message}"
  end
end
