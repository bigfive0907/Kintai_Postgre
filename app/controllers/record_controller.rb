class RecordController < ApplicationController
  def index
    @record = Record.all
  end



def show
    
    @record = Record.where(year:2023,month:3,day:2)
  if @record
   render("record/show")
  else
    @record = Record.where(year:2023)
    render("record/show")
  end
end



# 出勤を押したときの処理
def workStart
    Time.zone ="Asia/Tokyo"
    now = Time.zone.now

    @already = Record.find_by(year:now.year, month:now.month, day:now.day, name:@current_user.name,status:"出勤")
    if @already
      flash[:notice] = "既に出勤しています"
      redirect_to("/employee")
    else
      @record = Record.new(name: @current_user.name,
        year: now.year,
        month: now.month,
        day: now.day,
        time: now.time,
        status: "出勤")
      @record.save
      flash[:notice] = "出勤しました"
      redirect_to("/stats_new")
      
    end
end

# 退勤を押したときの処理
def workEnd
    Time.zone ="Asia/Tokyo"
    now = Time.zone.now
    #既に退勤を押しているか、出勤を押しているか
    already = Record.find_by(year:now.year,month:now.month,day:now.day, name:@current_user.name, status:"退勤")
    working = Record.find_by(year:now.year,month:now.month,day:now.day, name:@current_user.name, status:"出勤")
    if working
      #当日中に既に退勤を押している場合
      if already 
        flash[:notice] = "既に今日の勤務を終えています"
        redirect_to("/employee")
      
      #当日中に出勤のみを押している場合  正常
      else
        @record = Record.new(name: @current_user.name,
          year: now.year,
          month: now.month,
          day: now.day,
          time: now.time,
          status: "退勤")

        @record.save
        @worktime = working.time - @record.time
        flash[:notice] = "今日の勤務を終了しました"
        redirect_to("/stats_work")
        
      end
      #当日中に出勤を押していない場合
    else
      flash[:notice] = "今日はまだ出勤していません"
      redirect_to("/employee")
    end
    
end

# 休憩開始を押したときの処理  2回
def idleStart
    Time.zone ="Asia/Tokyo"
    now = Time.zone.now

    @record = Record.new(name: @current_user.name,
                        year: now.year,
                        month: now.month,
                        day: now.day,
                        time: now.time,
                        status: "休憩開始")

    @record.save
    
    flash[:notice] = "休憩を開始しました"
    redirect_to("/employee")
end


# 休憩終了を押したときの処理
def idleEnd
    Time.zone ="Asia/Tokyo"
    now = Time.zone.now
    #idling = Record.find_by(year:now.year,month:now.month,day:now.day, name:@current_user.name, status:"休憩開始")
    last_record = Record.where(name:@current_user.name).last
    if (last_record.status == "休憩開始")
    @record = Record.new(name: @current_user.name,
      year: now.year,
      month: now.month,
      day: now.day,
      time: now.time,
      status: "休憩終了")
    @record.save
    #休憩時間の追加
    @idletime = @record.time - last_record.time
    
    flash[:notice] = "休憩が終わりました"
    redirect_to("/stats_idle")
    
    else
      
        flash[:notice] = "休憩を開始していません"
        redirect_to("/employee")
    end
end

#勤務時間総量| 休憩時間総量| 残業時間総量
#              QK += qk
#終了ボタンを押したときtime=(最後の終了-最後の開始)
#最後が休憩開始だったら休憩終了を押せる
#最後が休憩開始だったら休憩開始

def overStart
  Time.zone ="Asia/Tokyo"
  now = Time.zone.now
  already = Record.find_by(year:now.year, month:now.month,day:now.day, name:@current_user.name, status:"残業開始")
  if already
    flash[:notice] = "既に残業を開始しています"
    redirect_to("/employee")
  else
    @record = Record.new(name: @current_user.name,
                    year: now.year,
                    month: now.month,
                    day: now.day,
                    time: now.time,
                    status: "残業開始")
    @record.save
    flash[:notice] = "残業を開始しました"
    redirect_to("/employee")
  end
end

# 退勤を押したときの処理
def overEnd
  Time.zone ="Asia/Tokyo"
  now = Time.zone.now
  #既に残業終了を押しているか、残業開始を押しているか
  already = Record.find_by(year:now.year,month:now.month,day:now.day, name:@current_user.name, status:"残業終了")
  working = Record.find_by(year:now.year,month:now.month,day:now.day, name:@current_user.name, status:"残業開始")
  if working
    #当日中に既に残業終了を押している場合
    if already 
      flash[:notice] = "既に今日の残業を終えています"
      redirect_to("/employee")
    
    #当日中に残業開始のみを押している場合  正常
    else
      @record = Record.new(name: @current_user.name,
        year: now.year,
        month: now.month,
        day: now.day,
        time: now.time,
        status: "残業終了")

      @record.save
      @overtime = working.time - @record.time
      flash[:notice] = "今日の残業を終了しました"
      redirect_to("/stats_over")
    end
    #当日中に残業開始を押していない場合
  else
    flash[:notice] = "今日はまだ残業を開始していません"
    redirect_to("/employee")
  end
  
end



end 