class BlogPost < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  validates :title, presence: true, length: { maximum: 255 }
  validates :content, presence: true
  validates :excerpt, length: { maximum: 500 }
  validates :image_url, format: { with: URI.regexp(%w[http https]), message: "must be a valid URL" }, allow_blank: true

  validate :image_format

  scope :published, -> { where(published: true, published_at: ...Time.current) }
  scope :by_recent, -> { order(created_at: :desc) }

def image_url
    if image.attached?
      Rails.application.routes.url_helpers.rails_blob_url(image, host: "localhost:3100")
    else
      super
    end
  end

  def publish!
    update(published: true, published_at: Time.current)
  end

  def unpublish!
    update(published: false, published_at: nil)
  end

  def published?
    published && published_at <= Time.current
  end

  private

  def image_format
    return unless image.attached?

    unless image.content_type.in?(%w[image/jpeg image/jpg image/png image/gif image/webp])
      errors.add(:image, "must be a JPEG, PNG, GIF, or WebP image")
    end
  end
end
