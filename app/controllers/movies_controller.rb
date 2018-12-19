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
    @movie = Movie.find_by(title: params[:title])
    data = MovieWrapper.search(params[:title])

  # data exists for the sole purpose of when someone tries to add a movie NOT through our web app (ex: postman)
  # if movie is not in our library, and also exists as a real movie in the external api, THEN add it
   if !@movie && !data.empty?
     new_movie = Movie.new(movie_params)

     if new_movie.save
       render json: new_movie.as_json(only: [:id]),
       status: :ok
     else
       render json: {
         ok: false,
         message: new_movie.errors.messages
         }, status: :bad_request
     end
   else
     render json: {
         ok: false,
         message: "Movie already exists in the library OR movie does not exist in this world."
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

  def movie_params
   params.permit(:title, :external_id, :overview, :image_url, :release_date)
 end

  def require_movie
    @movie = Movie.find_by(title: params[:title])
    unless @movie
      render status: :not_found, json: { errors: { title: ["No movie with title #{params["title"]}"] } }
    end
  end

end
