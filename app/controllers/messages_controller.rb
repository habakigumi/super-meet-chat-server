class MessagesController < ApplicationController
  protect_from_forgery :except => [:create]
  def create
    room = Room.find(params[:room_id])
    if (msg = room.messages.create(message_params))
      ActionCable.server.broadcast("room_#{room.key}",
                                   body: {
                                       id: msg.id,
                                       sender: msg.sender,
                                       value: msg.value,
                                       text: msg.text,
                                       super_chat_type: msg.super_chat_type
                                   }.to_json)
      render json: { result: 'OK' }
    else
      render json: { result: 'error', status: :bad_request, params: params }
    end
  end

  private

  def message_params
    params.require(:message).permit(
        :sender,
        :text
    )
  end
end
