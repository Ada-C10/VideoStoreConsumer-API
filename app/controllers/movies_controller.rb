class MoviesController < ApplicationController
  before_action :require_movie, only: [:show, :delete]

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

    if movie.save
      render json: { id: movie.id }, status:  :ok
    else
      render json: {
        errors: {
          title: ["Could not create '#{movie_params[:title]}' Movie"]
        },
        message: movie.errors.messages
        }, status: :bad_request
      end
    end

    def destroy
    end


    private

    def require_movie
      @movie = Movie.find_by(title: params[:title])
      unless @movie
        render status: :not_found, json: { errors: { title: ["No movie with title #{params["title"]}"] } }
      end
    end

    def movie_params
      params.permit(:title, :overview, :image_url, :release_date)
    end

  end
