class EventsController < ApplicationController
  def index
  end
  def new
    @event = Event.new(name: @user.name,starts_at: Time.now)
    @event.save
  end

  def edit
  end

  def start
    @event = Event.new(starts_at: Time.now)
    @event.save
  end
  
  def stop
    @event = Event.find_by(name:[:user_name])
    @event.new(stops_at: Time.now)
    @event.save
  end

  def isToday
    @event = Event.find_by(name:[:user_name], today:[today])
    if @event
      @error_message = "本日は既に出勤しています"
      render()
    else
      @event = Event.new(starts_at: Time.now)
    end
  end
end
