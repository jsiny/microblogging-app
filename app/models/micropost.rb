class Micropost < ApplicationRecord
  
  belongs_to :user
  default_scope -> { order(created_at: :desc)}    # Make sure that the newest post comes first
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: 140}
  
end
