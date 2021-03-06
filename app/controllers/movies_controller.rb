class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    if (params[:ratings].nil? && params[:sortby].nil?)
      if (!session[:ratings].nil?)
        ratings = session[:ratings]
        rates = Hash[ratings.collect{|x| [x, 1]}]
      end
      if (!session[:sortby].nil?)
        sort = session[:sortby]
      end
      redirect_to movies_path({:sortby=>sort, :ratings=>rates})
    end
    @all_ratings = Movie.all_ratings
    if (!params[:ratings].nil?)
      @ratings_to_show = params[:ratings].keys
    end
    if (!params[:sortby].nil?)
      @sortby = params[:sortby]
    end
    if (@ratings_to_show.nil?)
      @ratings_to_show = @all_ratings
    end
    @rates = Hash[@ratings_to_show.collect{|x| [x, 1]}]
    if(!@sortby.nil?)
      @movies = Movie.with_ratings(@ratings_to_show).order(@sortby)
      if (@sortby == "title")
        @titleclass = "hilite bg-warning"
      end
      if (@sortby == "release_date")
        @rdateclass = "hilite bg-warning"
      end
    else
      @movies = Movie.with_ratings(@ratings_to_show)
    end
    session[:ratings] = @ratings_to_show
    session[:sortby] = @sortby
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

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
