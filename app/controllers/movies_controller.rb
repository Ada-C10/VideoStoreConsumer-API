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

    if Movie.find_by(title: movie_params[:title]) == nil
      binding.pry
      movie = Movie.new(movie_params)

      if movie.save
        binding.pry
        render json: { id: movie.id }, status:  :ok
      else
        render json: {
          errors: {
            title: ["Could not create '#{movie_params[:title]}' Movie"]
          },
          message: movie.errors.messages
          }, status: :bad_request
      end
    else
      render json: {
        errors: {
          title: ["movie exists in db"]
        }
      }

    end
  end
  #
  #   else
  #     render json: {
  #       errors: {
  #         title: ["Movie:'#{movie_params[:title]}' already exists in own database"]
  #       }
  #   end
  # end

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
      params.permit(:title, :overview, :image_url, :release_date, :id)
    end

  end
