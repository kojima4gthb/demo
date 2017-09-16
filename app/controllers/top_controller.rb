class TopController < ApplicationController

  # def new
  #     render 'new'
  # end

  def create
    user = User.find_by_name params[:name]
    if user
      # セッションのキー:user_idへユーザーのIDを登録
      session[:user_name] = user.name
      redirect_to login_path
    else
      # flash変数にメッセージをセット
      flash.now.alert = 'もう一度入力してください。'
      render 'new'
    end
  end

end
