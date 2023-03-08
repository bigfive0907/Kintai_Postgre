class ManagerController < ApplicationController
  before_action :authenticate_manager,{only: [:edit, :show, :index, :update, :new]}
  def index
  end

  def new
    @manager = Manager.new
  end

  def show
    @manager = Manager.all
  end

  def edit
    @manager = Manager.find_by(id:@current_manager.id)
    
  end

  def update
    @manager = Manager.find_by(id:@current_manager.id)
    @manager.email = params[:email]
    @manager.tell = params[:tell]
    @manager.password = params[:password]

    if @manager.save
      flash[:notice] = "ユーザー情報が更新されました"
      redirect_to("/manager")
    else
      flash[:notice] = "ユーザー情報の更新に失敗しました"
      render("manager/edit")
    end

  end

  def create
    @manager = Manager.new(name:params[:name],email:params[:email],password:params[:password])
    if @manager.save
      session[:manager_id] = @manager.id
      flash[:notice] = "ユーザー登録が完了しました"
      
    redirect_to("/manager")
    
    else 
      flash[:notice] = "ユーザー登録に失敗しました"
      @name = params[:name]
      @email = params[:email]
      @password = params[:password]
      render("manager/new")
    end
  end

  def login_manager
    @manager = Manager.find_by(email: params[:email])
    if @manager && @manager.authenticate(params[:password])
      session[:manager_id] = @manager.id
      flash[:notice] = "管理者としてログインしました"
      if @current_user
        session[:user_id] = nil
      end
      redirect_to("/manager")
    
    else
      @error_message = "メールアドレス、パスワードのいずれかが異なります"
      
      render("manager/login_manager_form")
    end
  end

  def login_manager_form
    if @current_manager
      redirect_to("/manager")
    end
  end
end
