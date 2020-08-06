class Message < ApplicationRecord
  belongs_to :room

  before_save :set_super_chat
  before_save :un_super_chat!

  enum super_chat_type: {
      normal: 0,
      blue: 10,
      light_blue: 20,
      yellow_green: 30,
      yellow: 40,
      orange: 50,
      pink: 90,
      red: 100
  }, _prefix: true

  private
  def super_chat_value_str
    if self.text =~ /\A.*(¥[0-9,]+).*/
      $1
    else
      nil
    end
  end

  def un_super_chat!
    self.text.gsub! /\A¥[0-9,]+\s*/, ''
  end

  def set_super_chat
    if (result = super_chat_value_str)
      value = result[1..-1].gsub(',', '_').to_i
      self.value = value
      if value < 200
        self.super_chat_type = :blue
      elsif value < 500
        self.super_chat_type = :light_blue
      elsif value < 1000
        self.super_chat_type = :yellow_green
      elsif value < 2000
        self.super_chat_type = :yellow
      elsif value < 5000
        self.super_chat_type = :orange
      elsif value < 10000
        self.super_chat_type = :pink
      else
        self.super_chat_type = :red
      end
    end
  end
end
