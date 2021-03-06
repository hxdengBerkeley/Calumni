class CalumnisController < ApplicationController

#   before_action :get_game_from_session
#   after_action  :store_game_in_session

  include CalumnisHelper
  private

#   def get_game_from_session
#     @game = HangpersonGame.new('')
#     if !session[:game].blank?
#       @game = YAML.load(session[:game])
#     end
#   end

#   def store_game_in_session
#     session[:game] = @game.to_yaml
#   end

  def people_params
    params.require(:people).permit(:username,:lastname, :email, :description, :company, :start_date, :resume, :university, :major, :graduation, :help, :position,:avatar,:graduation_date,:helpability,:major,:open_advice,:role)
  end

  public
  # def new
  # end
  def new
    @calumni=People.new()
  end

  def home
    @people= People.select{|p| p.email==cookies[:email]}
    @mentor1= People.select{|p| p.email=="yima@uiuc.edu"}
    @mentor2= People.select{|p| p.email=="1@gmail.com"}
    @mentor3= People.select{|p| p.email=="2@gmail.com"}
    @mentor4= People.select{|p| p.email=="3@gmail.com"}
  end
  def signup
  end

  # not go to this function anymore
  def createandlogin
    # p "in createandlogin",params[:people],people_params,cookies[:email]
    params[:people][:email]=cookies[:email]
    people_params[:email]=cookies[:email]
    # p people_params,"again"
    @calumni = People.create!(people_params)
    redirect_to profile_path
  end
  def login

  end


  def edit_profile
    # p cookies[:email]
    @people= People.select{|p| p.email==cookies[:email]}
  end

  def upload
    @people= People.select{|p| p.email==cookies[:email]}
  end
  def receiveimg
        @people= People.select{|p| p.email==cookies[:email]}
        @people.first.update_attributes(people_params)
        @people.first.save
        redirect_to profile_path
  end
  def search
    @people= People.select{|p| p.email==cookies[:email]}
    @num=[]
    # modify type
    if params[:type]=='user'
      params[:type]='username'
    end
    # if no type, default search username
    @type=params[:type]||'username'
    @type_index=0
    # vague search
    ['username','company','description'].each_with_index do |i,index|
      @search = People.search(params[:search].downcase,i).order("created_at DESC")  
      if not @search.to_a.first.nil?
        @num.push(@search.to_a.length())
      else
        @num.push(0)
      end
      if i==@type
        @search_ret=@search
        @type_index=index
      end
    end
    @search_key=params[:search]
    
    # modify type
    if @type=='username'
      @type='user'
    end

  end

  def become_mentor
     @people= People.select{|p| p.email==cookies[:email]}
     @people.first.update_attribute(:role,'mentor')
     # byebug
     redirect_to edit_profile_path
  end

  def render_404
    respond_to do |format|
      format.html { render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found }
      format.xml  { head :not_found }
      format.any  { head :not_found }
    end
  end
  def showprofile

    @people= People.select{|p| p.email==cookies[:email]}
    @otheruser= People.select{|p| p.username==params[:username]}
    # if user not exist
    if @otheruser.first.nil?
      render_404
    end
    # if user=otheruser
    if @people==@otheruser
      redirect_to profile_path
    end



  end

  def profile

    # check username and password first
    # p params

    # save
    p cookies[:email]
    @people= People.select{|p| p.email==cookies[:email]}
    # p "in profile ",People.find_by(email: cookies[:email])

    # @pwcorrect=People.find_by(username: params[:people][:username], password: params[:people][:password])

    # p @pwcorrect
    # if @pwcorrect
    #   @people=1
    # else
    #   @pwcorrect="Wrong Username or Password"
    #   render :login
    # end
  end

  def create_account
    # use oauth login first
      # use before action

    # check user exists or not
    p @people
    ok= People.select{|p| p.email==cookies[:email]}
    # if user exists
    p "this is ok",ok
    # byebug
    if ok.first!=nil # old user
      cookies[:username]=ok.first.username
    else #new user
      cookies[:username]=cookies[:email]
      # add email
      @calumni=People.new()
      @calumni.update_attributes(email:cookies[:email],username:cookies[:name],lastname:cookies[:lastname])
      @calumni.update_attribute(:role,'mentee')
      # tmp_params = ActionController::Parameters.new(email:cookies[:email])
      # People.create!(tmp_params)
    end
    redirect_to home_path

    # redirect to previous page
    # redirect_to home_path
    # byebug
    # redirect_to request.path

    # return an array, if [] or has value
    # if ok[0]!=nil
    #   redirect_to profile_path
    # end
  end
  def create_mentee
  end
  def edit_error
  end
  def update_profile
    
    if people_params[:avatar]
      if people_params[:avatar].size >100.megabytes
        redirect_to edit_error_path and return
      end
      if !["image/jpg","image/jpeg","image/png","image/gif"].include? people_params[:avatar].content_type
        redirect_to edit_error_path and return
      end
    end
    if people_params[:resume]
      if people_params[:resume].size >100.megabytes
        redirect_to edit_error_path and return
      end
      if !["application/pdf"].include? people_params[:resume].content_type
        redirect_to edit_error_path and return
      end
    end
    @people= People.select{|p| p.email==cookies[:email]}
    @people.first.update_attributes(people_params)
    redirect_to profile_path and return
  end



  # def create
  #   @movie = Movie.create!(movie_params)
  #   flash[:notice] = "#{@movie.title} was successfully created."
  #   redirect_to movies_path
  # end


#   def show
#     status = @game.check_win_or_lose
#     redirect_to win_game_path if status == :win
#     redirect_to lose_game_path if status == :lose
#   end

#   def guess
#     letter = params[:guess]
#     begin
#       if ! @game.guess(letter[0])
#         flash[:message] = "You have already used that letter."
#       end
#     rescue ArgumentError
#       flash[:message] = "Invalid guess."
#     end
#     redirect_to game_path
#   end

#   def win
#     redirect_to game_path unless @game.check_win_or_lose == :win
#   end

#   def lose
#     redirect_to game_path unless @game.check_win_or_lose == :lose
#   end

end
