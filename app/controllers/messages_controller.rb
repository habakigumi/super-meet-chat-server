class MessagesController < ApplicationController
  protect_from_forgery :except => [:create]

  def create
    room = Room.find_or_create_by!(key: params[:room_key])
    if (msg = room.messages.create(message_params))
      broadcast_message room, msg
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

  def broadcast_message(room, msg)
    ActionCable.server.broadcast("room_#{room.key}",
                                 body: {
                                     id: msg.id,
                                     sender: msg.sender,
                                     value: msg.value,
                                     text: msg.text,
                                     super_chat_type: msg.super_chat_type
                                 }.to_json)
  end
end
