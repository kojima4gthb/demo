class ContentsController < ApplicationController

  def index
    if current_user == nil
      redirect_to top_path
    end
  end

end
