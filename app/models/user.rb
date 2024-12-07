class User < ApplicationRecord
  has_one :user_credential, dependent: :destroy
  has_many :user_sessions, dependent: :destroy
end
