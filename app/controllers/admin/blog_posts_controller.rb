class Admin::BlogPostsController < ApplicationController
  before_action :require_admin
  before_action :set_blog_post, only: [ :edit, :update, :destroy, :publish, :unpublish ]
  def index
    @blog_posts = BlogPost.includes(:user).order(created_at: :desc)
    render inertia: "admin/blog_posts/Index", props: {
      blogPosts: @blog_posts.as_json(include: :user),
      flash: flash.to_hash
    }
  end

  def new
  @blog_post = BlogPost.new
    render inertia: "admin/blog_posts/New"
  end

  def create
    Rails.logger.info "=== BLOG POST CREATE DEBUG ==="
    Rails.logger.info "Raw params: #{params.to_unsafe_h.inspect}"
    Rails.logger.info "blog_post_params result: #{blog_post_params.inspect}"

    @blog_post = BlogPost.new(blog_post_params)
    @blog_post.user = Current.user
    @blog_post.author = Current.user.email_address.split("@").first.capitalize

    if @blog_post.save
      # Handle image upload via blob ID if provided
      if params[:blob_id].present?
        blob = ActiveStorage::Blob.find_signed(params[:blob_id])
        @blog_post.image.attach(blob) if blob
      end
      handle_image_upload
      flash[:notice] = "Blog post was successfully created."
      redirect_to admin_blog_posts_path
    else
      Rails.logger.info "Failed: #{@blog_post.errors.full_messages.join(', ')}"
      render inertia: "admin/blog_posts/New", props: {
        blogPost: @blog_post.as_json,
        errors: @blog_post.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def edit
    render inertia: "admin/blog_posts/Edit", props: {
      blogPost: @blog_post.as_json
    }
  end

  def update
    Rails.logger.info "=== BLOG POST UPDATE DEBUG ==="
    Rails.logger.info "Raw params: #{params.to_unsafe_h.inspect}"
    Rails.logger.info "blog_post_params result: #{blog_post_params.inspect}"

    if @blog_post.update(blog_post_params)
      handle_image_upload
      flash[:notice] = "Blog post was successfully updated"
      redirect_to admin_blog_posts_path
    else
      render inertia: "admin/blog_posts/Edit", props: {
        blogPost: @blog_post.as_json,
        errors: @blog_post.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def destroy
    @blog_post.destroy
    redirect_to admin_blog_posts_path, notice: "Blog post was successfully deleted."
  end

  def publish
    @blog_post.publish!
    redirect_to admin_blog_posts_path, notice: "Blog post was successfully published."
  end

  def unpublish
    @blog_post.unpublish!
    redirect_to admin_blog_posts_path, notice: "Blog post was successfully unpublished."
  end

def upload_image
    if params[:image].present?
      if params[:id].present?
        # Member route - existing post
        @blog_post = BlogPost.find(params[:id])
        @blog_post.image.attach(params[:image])
render json: {
          image_url: rails_blob_url(@blog_post.image, host: "localhost:3100"),
          success: true
        }
      else
        # Collection route - create blob directly for new posts
        blob = ActiveStorage::Blob.create_and_upload!(
          io: params[:image],
          filename: params[:image].original_filename,
          content_type: params[:image].content_type
        )

render json: {
          image_url: rails_blob_url(blob, host: "localhost:3100"),
          blob_id: blob.signed_id,
          success: true
        }
      end
    else
      render json: {
        error: "No image provided",
        success: false
      }, status: :unprocessable_entity
    end
  end

  private

  def require_admin
    redirect_to root_path, alert: "Access denied." unless Current.user&.admin?
  end

  def set_blog_post
    @blog_post = BlogPost.find(params[:id])
  end

  def blog_post_params
    # Handle both wrapped parameters from Rails forms and unwrapped parameters from Inertia/JSON
    if params[:blog_post].present?
      params.require(:blog_post).permit(:title, :content, :excerpt, :author, :image_url)
    elsif params["title"].present?
      {
        title: params["title"],
        content: params["content"],
        excerpt: params["excerpt"],
        author: params["author"],
        image_url: params["image_url"]
      }
    else
      {}
    end
  end

  def handle_image_upload
    if params[:image].present?
      @blog_post.image.attach(params[:image])
    end
  end
end
