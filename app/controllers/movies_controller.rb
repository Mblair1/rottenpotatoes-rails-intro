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
    #Check to see if we have clicked a link to sort our column of movies
    #And store them into the session hash if possible
    if params.key?(:clicked)
			session[:clicked] = params[:clicked]
		elsif session.key?(:clicked)
			params[:clicked] = session[:clicked]
			redirect_to movies_path(params) and return
	  end
	  
	  #Check the session hash to determine which way we would like to sort our movies
    if session[:clicked] == 'title'
      @clicked = 'title'
    elsif session[:clicked] == 'release_date'
      @clicked = 'release_date'
    end
   
   #Check if we have any raitings we would like to filter by
   #And store them into the session hash if possible
	  if params.key?(:ratings)
			session[:ratings] = params[:ratings]
		elsif session.key?(:ratings)
			params[:ratings] = session[:ratings]
			redirect_to movies_path(params) and return
		else
		  @selected_ratings = Movie.ratings
		  @all_ratings = Movie.ratings
		end
		
		#If our session has no ratings, then we must not have any ratings we wish to
		#Filter by, then we must set initial conditions to load our application
		#By setting @all_ratings and @selected_ratings
    if session.key?(:ratings)
      @all_ratings = Movie.ratings
      @selected_ratings = session[:ratings]
    else
      @selected_ratings = Movie.ratings
    end
    
    #Filter our our movies by the ratings selected. If no ratings are selected,
    #Order by whatever column head is clicked.
    if session.key?(:ratings)
      @movies = Movie.order(session[:clicked])
    
      if(session[:ratings].keys.any?)
        @movies = @movies.where(:rating => session[:ratings].keys)
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
