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
    if movie_params[:image_url] != nil
      url = movie_params[:image_url]
      url = url.slice(31, url.length)
    else
      url = movie_params[:image_url]
    end
    movie = Movie.new({external_id: movie_params[:external_id],
                        overview: movie_params[:overview],
                        image_url: url,
                        release_date: movie_params[:release_date],
                        title: movie_params[:title],
                        inventory: movie_params[:inventory]})
    if movie.save
      render json: {
        id: movie.id,
        title: movie.title,
        overview: movie.overview,
        image_url: movie.image_url,
        release_date: movie.release_date,
        inventory: movie.inventory,
        external_id: movie.external_id }, status: :ok
    else
      if movie.errors.messages[:external_id] == ["has already been taken"]
        render json: {
          errors: "Hmm...
          We think you already have that movie in your film library."
        }, status: :bad_request
      else
        render json: {
          errors: movie.errors.messages
        }, status: :bad_request
      end
    end

  end

  def show
    render(
      status: :ok,
      json: @movie.as_json(
        only: [:title, :overview, :release_date, :inventory, :image_url],
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
