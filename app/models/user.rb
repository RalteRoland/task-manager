class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :tasks, dependent: :destroy
  has_many :comments, dependent: :nullify

  has_many :assigned_tasks, class_name: 'Task', foreign_key: 'assignee_id', dependent: :nullify

  # Add token authentication
  before_save :ensure_authentication_token

  def name
    self[:name].presence || email
  end

  private

  def ensure_authentication_token
    self.authentication_token ||= generate_authentication_token
  end

  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end
end
