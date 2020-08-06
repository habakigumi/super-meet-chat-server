class RoomsController < ApplicationController
  def index
    @rooms = Room.all
  end

  def show
    @room = Room.includes(:messages).find_by!(key: params[:key])
    @messages = @room.messages
  end
end
