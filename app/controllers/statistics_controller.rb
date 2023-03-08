class StatisticsController < ApplicationController
  before_action :authenticate_manager,{only:[:show]}
  def index
  end
 
  def show
      @id = params[:id]
      @user = User.find_by(id:@id)
      @year = params[:year].to_i
      @month = params[:month].to_i

      if @year && @year != 0
        if @month && @month != 0
          @stats = Statistic.where(name: @user.name, year: @year, month: @month)
          
        end
      else
        @stats = Statistic.where(name: @user.name)
      end
  end
  
  def dateSearch
    
    redirect_to("/statistics/#{params[:id]}/#{params[:year]}/#{params[:month]}")
  end
  #出勤を押した時点でDBを作製
  def new
    Time.zone ="Asia/Tokyo"
    now = Time.zone.now
    default = 0
    @stats = Statistic.new(name: @current_user.name,
                        year: now.year,
                        month: now.month,
                        day: now.day,
                        worktime: default,
                        idletime: default,
                        overtime: default,
                        )
    @stats.save
    redirect_to("/employee")
  end

  def editIdle
    Time.zone ="Asia/Tokyo"
    now = Time.zone.now
    record_s = Record.find_by(year:now.year,month:now.month,day:now.day, name:@current_user.name, status:"休憩開始")
    record_e = Record.find_by(year:now.year,month:now.month,day:now.day, name:@current_user.name, status:"休憩終了")
    @stats = Statistic.find_by(name: @current_user.name,
                                year: now.year,
                                month: now.month,
                                day: now.day
    )
    @stats.idletime += record_e.time - record_s.time
    @stats.save
    redirect_to("/employee")
  end

  def editWork
    
    Time.zone ="Asia/Tokyo"
    now = Time.zone.now
    record_s = Record.find_by(year:now.year,month:now.month,day:now.day, name:@current_user.name, status:"出勤")
    record_e = Record.find_by(year:now.year,month:now.month,day:now.day, name:@current_user.name, status:"退勤")

    @stats = Statistic.find_by(name: @current_user.name,
                                year: now.year,
                                month: now.month,
                                day: now.day
    )
    @stats.worktime = record_e.time - record_s.time
    @stats.save
    redirect_to("/employee")
  end

  def editOver
    Time.zone ="Asia/Tokyo"
    now = Time.zone.now
    record_s = Record.find_by(year:now.year,month:now.month,day:now.day, name:@current_user.name, status:"残業開始")
    record_e = Record.find_by(year:now.year,month:now.month,day:now.day, name:@current_user.name, status:"残業終了")
    @stats = Statistic.find_by(name: @current_user.name,
                                year: now.year,
                                month: now.month,
                                day: now.day
    )
    @stats.overtime = record_e.time - record_s.time
    @stats.save
    redirect_to("/employee")
  end
  #退勤を押した時点で当日のログインユーザーのデータを退勤時間ー出勤時間でedit
  #休憩、残業も同様

end
