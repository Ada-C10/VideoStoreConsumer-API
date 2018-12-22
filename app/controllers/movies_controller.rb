require 'pry'

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
    movie = Movie.new(movie_params)
    if movie.save!
      render json: {id: movie.id,
        title: movie.title,
        overview: movie.overview,
        release_date: movie.release_date,
        external_id: movie.external_id,
        image_url: movie.image_url}, status: :ok
    end
  end


  private

  def movie_params
    params.permit(:title, :overview, :release_date, :external_id, :image_url)
  end


  def require_movie
    binding.pry
    @movie = Movie.find_by(title: params[:title])
    unless @movie
      render status: :not_found, json: { errors: { title: ["No movie with title #{params["title"]}"] } }
    end
  end
end
