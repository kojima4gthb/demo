class LoginsController < ApplicationController
  include Common

  def new
    if current_user_name == nil
      redirect_to top_path
    end
  end

  def create
    user = User.find_by_name current_user_name
    passwd = '' 
    # パスワードIDを文字列に変換
    params[:pass].split(',').each { |id|
        passwd += get_alphabet(id.to_i)
    }
    if user && user.authenticate(passwd)
      # セッションのキー:user_idへユーザーのIDを登録
      session[:user_id] = user.id
      session[:user_name] = nil
      redirect_to main_path
    else
      # flash変数にメッセージをセット
      flash.now.alert = 'もう一度入力してください。'
      params[:pass] = ''
      render 'new'
    end
  end

  def destroy
    session[:user_id] = nil
    session[:user_name] = nil
    @current_user = nil
    redirect_to top_path
  end

  def current_user_name
    if session[:user_name]
      session[:user_name]
    end
  end

  helper_method :current_user_name

end
