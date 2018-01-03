#require 'sendgrid-ruby'
#include SendGrid

class NoticeMailer < ActionMailer::Base
  default from: 'noreply@example.com'
  def sendmail_confirm(record, url)
    # body = '新しいコメントが登録されました。/n/n'
    # body += '承認または削除してください。/n/n'
    # body += '承認または削除してください。/n/n'
    # body += 'Blog: ' + record.entry.blog.title + '/n'
    # body += 'Entry: ' + record.entry.title + '/n'
    # body += 'Comment: ' + record.body + '/n/n'
    # body += 'URL: ' + url + '?permission=admin'
    #
    # from = Email.new(email: 'test@example.com')
    # subject = '新しいコメントが投稿されました。'
    # to = Email.new(email: 'kojima4biz@gmail.com')
    # content = Content.new(type: 'text/plain', value: body)
    # mail = Mail.new(from, subject, to, content)
    #
    # sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
    # response = sg.client.mail._('send').post(request_body: mail.to_json)
    # puts response.status_code
    # puts response.body
    # puts response.headers
    @record = record
    @url = url
    mail to: 'kojima4biz@gmail.com',
         subject: '新しいコメントが投稿されました。'
  end

end
