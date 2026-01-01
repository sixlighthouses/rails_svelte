class PagesController < ApplicationController
  allow_unauthenticated_access

  def home
    render inertia: "Home"
  end

  def about
    render inertia: "About"
  end

def blog
    @blog_posts = BlogPost.published.by_recent
    render inertia: "Blog", props: {
      blogPosts: @blog_posts.as_json
    }
  end

  def show_blog_post
    @blog_post = BlogPost.published.find(params[:id])
    render inertia: "ShowBlogPost", props: {
      blogPost: @blog_post.as_json
    }
  rescue ActiveRecord::RecordNotFound
    redirect_to blog_path, alert: "Blog post not found."
  end

  def create_flash
    flash[:notice] = "This is a notice"
    flash[:alert] = "This is an alert"
    flash[:error] = "This is an error"
    redirect_to root_path
  end
end
