class BlogsController < ApplicationController
  before_action :set_blog, only: [:show, :edit, :update, :destroy]

  # GET /blogs
  def index
    @blogs = Blog.all
  end

  # GET /blogs/1
  def show
    correct_routes?(%w(blogs index), %w(blogs show), %w(blogs edit),
                    %w(entries new), %w(entries create), %w(entries edit), %w(entries show))
  end

  # GET /blogs/new
  def new
    return unless correct_routes?(%w(blogs index))

    @blog = Blog.new
  end

  # GET /blogs/1/edit
  def edit
    correct_routes?(%w(blogs index), %w(blogs show))
  end

  # POST /blogs
  def create
    return unless correct_routes?(%w(blogs new))

    blog = Blog.new(blog_params)

    respond_to do |format|
      if blog.save
        format.html { redirect_to blogs_path, notice: 'Blog was successfully created.' }
      else
        format.html { redirect_to blogs_path, notice: blog.errors.full_messages[0] }
      end
    end
  end

  # PATCH/PUT /blogs/1
  def update
    return unless correct_routes?(%w(blogs edit))

    respond_to do |format|
      if @blog.update(blog_params)
        format.html { redirect_to blogs_path, notice: 'Blog was successfully updated.' }
      else
        format.html { redirect_to blogs_path, notice: @blog.errors.full_messages[0] }
      end
    end
  end

  # DELETE /blogs/1
  def destroy
    return unless correct_routes?(%w(blogs index))

    @blog.destroy
    respond_to do |format|
      format.html { redirect_to blogs_path, notice: 'Blog was successfully destroyed.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_blog
      @blog = Blog.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def blog_params
      params.require(:blog).permit(:title)
    end
end
