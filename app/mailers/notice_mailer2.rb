class NoticeMailer2 < ActionMailer::Base
  default from: 'noreply@example.com'
  def sendmail_confirm(record, url)
    @record = record
    @url = url
    mail to: 'admin@example.com',
         subject: '新しいコメントが投稿されました。'
  end
end
