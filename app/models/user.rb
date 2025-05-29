class User < ApplicationRecord
  # Devise modules - default ones you had
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :tasks, dependent: :destroy
end
