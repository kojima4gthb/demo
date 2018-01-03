class EntriesController < ApplicationController
  before_action :set_entry, only: [:show, :edit, :update, :destroy]

  # GET /entries/1
  def show
    unless params[:permission].eql? 'admin'
      return unless correct_routes?(%w(blogs show), %w(entries edit), %w(entries show))
    end

    @comment = Comment.new(entry_id: params[:id], status: 'unapproved')
  end

  # GET /entries/new
  def new
    return unless correct_routes?(%w(blogs show))

    @entry = Entry.new(blog_id: params[:blog_id])
  end

  # GET /entries/1/edit
  def edit
    correct_routes?(%w(blogs show), %w(entries show))
  end

  # POST /entries
  def create
    return unless correct_routes?(%w(entries new))

    entry = Entry.new(entry_params)
    respond_to do |format|
      if entry.save
        format.html { redirect_to blog_path(entry.blog), notice: 'Entry was successfully created.' }
      else
        format.html { redirect_to blog_path(entry.blog), notice: entry.errors.full_messages[0] }
      end
    end
  end

  # PATCH/PUT /entries/1
  def update
    return unless correct_routes?(%w(entries edit))

    respond_to do |format|
      if @entry.update(entry_params)
        format.html { redirect_to blog_path(@entry.blog), notice: 'Entry was successfully updated.' }
      else
        format.html { redirect_to blog_path(@entry.blog), notice: @entry.errors.full_messages[0] }
      end
    end
  end

  # DELETE /entries/1
  def destroy
    return unless correct_routes?(%w(blogs show))

    @entry.destroy
    respond_to do |format|
      format.html { redirect_to blog_path(@entry.blog), notice: 'Entry was successfully destroyed.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_entry
      @entry = Entry.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def entry_params
      params.require(:entry).permit(:title, :body, :blog_id)
    end
end
