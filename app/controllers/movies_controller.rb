class MoviesController < ApplicationController
  before_action :require_movie, only: [:show]

  def index
    if params[:query]
      data = MovieWrapper.search(params[:query])
    else
      data = Movie.all
    end

    render status: :ok, json: data
  end

  def show
    render(
      status: :ok,
      json: @movie.as_json(
        only: [:title, :overview, :release_date, :inventory],
        methods: [:available_inventory]
      )
    )
  end

  def create
    movie_exists = Movie.find_by(external_id: params[:id])
    if movie_exists
      render status: :bad_request, json: {errors: {movie: "Movie already exists in library"}}
    else
      movie = MovieWrapper.get_movie(params[:id])

      if movie
        movie.save
        render(
          status: :ok, json: movie.as_json( only: [:title] )
        )
      else
        #errors
        render(
          status: :bad_request, json: {errors: {movie: "bad data, somehow"}}
        )
      end
    end
  end

  private

  def require_movie
    @movie = Movie.find_by(title: params[:title])
    unless @movie
      render status: :not_found, json: { errors: { title: ["No movie with title #{params["title"]}"] } }
    end
  end
end
