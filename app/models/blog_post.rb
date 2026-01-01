class BlogPost < ApplicationRecord
  belongs_to :user

  validates :title, presence: true, length: { maximum: 255 }
  validates :content, presence: true
  validates :excerpt, length: { maximum: 500 }
  validates :image_url, format: { with: URI.regexp(%w[http https]), message: "must be a valid URL" }, allow_blank: true

  scope :published, -> { where(published: true, published_at: ...Time.current) }
  scope :by_recent, -> { order(created_at: :desc) }

  def publish!
    update(published: true, published_at: Time.current)
  end

  def unpublish!
    update(published: false, published_at: nil)
  end

  def published?
    published && published_at <= Time.current
  end
end
