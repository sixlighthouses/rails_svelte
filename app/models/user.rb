class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :blog_posts, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }
  validates :email_address, presence: true, uniqueness: { case_sensitive: false }, format: {
    with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i,
    message: "must be a valid email address"
  }
  validates :password, confirmation: true, length: {
    minimum: 6,
    maximum: 72,
    message: "must be between 6 and 72 characters"
  }

  def admin?
    admin
  end
end
