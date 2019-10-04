class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    
    
    
   
    if params.key?(:ratings)
      ratingsArr = params[:ratings].keys
      @all_ratings = Movie.ratings
    else
      ratingsArr = @all_ratings = Movie.ratings
    end
    
    if params[:clicked] == 'title'
      @clicked = 'title'
    elsif params[:clicked] == 'release_date'
      @clicked = 'release_date'
    end

    if params.key?(:ratings)
      @movies = []
      ratingsArr.each do |rating|
        @movies += Movie.where(rating: rating)
      end
    else
      @movies = Movie.order(params[:clicked])
    end
    
    
  end
 
  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
