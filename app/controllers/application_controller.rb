class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def current_user
    if session[:user_id]
      # @current_userがnilかfalseならログインユーザーを代入
      @current_user ||= User.find(session[:user_id])
    end
  end

  helper_method :current_user

  private

    def correct_routes?(*paths)
      begin
        rf = Rails.application.routes.recognize_path(request.referrer)
        paths.each do |path|
          if (rf[:controller].eql? path[0]) && (rf[:action].eql? path[1])
            return true
          end
        end
      rescue => e
        p 'illegal routes [' + e.message + ']'
      end

      respond_to do |format|
        format.html {
          redirect_to blogs_path
          return false
        }
      end
    end

    def send_mail(type, record, url)
      if type.eql? :notice
        if ENV['RAILS_ENV'].eql? 'production'
          #NoticeMailer.sendmail_confirm(record, url).deliver
        else
          NoticeMailer2.sendmail_confirm(record, url).deliver
        end
      end
    end

end
