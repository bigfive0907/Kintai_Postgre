class UsersController < ApplicationController
  before_action :authenticate_user,{only: [:edit, :index, :update, :employee, :destroy]}
  before_action :authenticate_manager,{only:[:new, :show]}
  def index
    @user = User.all
  end
  
  def new
    @user = User.new
  end

  def show
    @user = User.all
  end
  
  def edit
    @user = User.find_by(id:params[:id])
    
  end


  def update
    @user = User.find_by(id: params[:id])

    @user.email = params[:email]
    @user.tell = params[:tell]
    @user.password = params[:password]

    if @user.save
      flash[:notice] = "ユーザー情報が更新されました"
      redirect_to("/employee")
    else
      render("users/edit")
    end

  end

  def employee
    @record = Record.all.order(id: "DESC")
    @record = @record.where(name: @current_user.name)
    
  end

  def create
    @user = User.new(name:params[:name],email:params[:email],password:params[:password])
    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = "ユーザー登録が完了しました"
    redirect_to("/show")
    
    else 
      flash[:notice] = "ユーザー登録に失敗しました"
      @name = params[:name]
      @email = params[:email]
      @password = params[:password]
      render("users/create")
    end
  end

  def login
    
    @user = User.find_by(name: params[:name])
    @record = Record.find_by(name: @user.name)
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      flash[:notice] = "従業員としてログインしました"
      if @current_manager
        session[:manager_id] = nil
      end
      redirect_to("/employee")
  
    else
      @error_message = "ユーザー名、パスワードのいずれかが異なります"
      @email = params[:email]
      @password = ""
      
      render("login_form")
    end
    
  end

  def login_form
    if @current_user
      redirect_to("/employee")
    end
  end

  

  def logout
    session[:user_id] = nil
    session[:manager_id] = nil
    flash[:notice] = "ログアウトしました"
    redirect_to("/")
    
  end

=begin
  require 'csv'


  def index
    @users = User.all

    respond_to do |format|
      format.html
      format.csv do |csv|
        send_users_csv(@users)
      end
    end
  end

  def send_users_csv(users)
    csv_data = CSV.generate do |csv|
      header = %w(id name email tell)
      csv << header

      users.each do |user|
        values = [user.id,user.name,user.email,user.tell]
        csv << values
      end

    end
    send_data(csv_data, filename: "users.csv")
  end
=end

end

