class User < ApplicationRecord
  has_one :user_credential, dependent: :destroy
  accepts_nested_attributes_for :user_credential
  has_many :user_sessions, dependent: :destroy
end
