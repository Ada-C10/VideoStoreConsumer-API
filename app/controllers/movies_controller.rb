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

  def create
    movie = Movie.new(movie_params)
    if movie.save
      render json: {
        id: movie.id,
        title: movie.title,
        external_id: movie.external_id }, status: :ok
    else
      render json: {
        message: movie.errors.messages
      }, status: :bad_request
    end
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

  private

  def require_movie
    @movie = Movie.find_by(title: params[:title])
    unless @movie
      render status: :not_found, json: { errors: { title: ["No movie with title #{params["title"]}"] } }
    end
  end

  def movie_params
    params.permit(:external_id, :image_url, :overview, :release_date, :title, :inventory)
  end
end
