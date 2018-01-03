require 'rails_helper'

feature 'Comment管理' do
  background do
    @blog = Blog.create!(title: 'ねこがすき！にゃんにゃんブログ')
    @entry = @blog.entries.create!(title: 'はじめてのエントリー', body: 'はじめまして！')
    @entry.comments.create!(body: 'てすてす	', status: 'unapproved')
    visit blogs_path
    click_link 'Show'
    click_link 'Show'
  end
  context '新規作成の場合' do
    scenario 'Commentの新規作成時にtitleを入力しなかった場合にエラーが表示されること' do
      # 新規作成フォームにタイトルを入力しない
      fill_in 'Body', with: ''
      # Saveボタンをクリックする
      expect {
        click_button 'Save'
      }.to change(Comment, :count).by(0)
      # ブログ閲覧画面に遷移したことを検証する
      expect(current_path).to eq blog_entry_path(@blog, @entry)
      expect(page).to have_content "Body can't be blank"
    end
    scenario 'Commentの新規作成時にtitleを入力した場合はデータが保存され閲覧画面に遷移すること' do
      # 新規作成フォームにタイトルを入力する
      fill_in 'Body', with: 'ねこはかわいいですよね'
      # Saveボタンをクリックする
      expect {
        click_button 'Save'
      }.to change(Comment, :count).by(1)
      # ブログ閲覧画面に遷移したことを検証する
      expect(current_path).to eq blog_entry_path(@blog, @entry)
      expect(page).to have_content 'Comment was successfully created.'
    end
  end
  context '承認の場合' do
    scenario 'Commentの承認時にtitleを入力した場合はデータが承認され閲覧画面に遷移すること' do
      # 承認前であることを検証する
      expect(page).to have_content '(承認待ち)'
      # Saveボタンをクリックする
      expect {
        click_link 'Approve'
      }.to change(Comment, :count).by(0)
      # ブログ閲覧画面に遷移したことを検証する
      expect(current_path).to eq blog_entry_path(@blog, @entry)
      expect(page).to have_content 'Comment was successfully approved.'
      expect(page).to_not have_content '(承認待ち)'
      expect(page).to_not have_content 'Approve'
    end
  end
end
