require 'rails_helper'

feature 'Blog管理' do
  background do
    # Blogを作成する
    @blog = Blog.create!(title: 'ねこがすき！にゃんにゃんブログ')
    visit blogs_path
  end
  context '新規作成の場合' do
    background do
      # 新規作成ページを開く
      click_link 'New Blog'
    end
    scenario 'Blogの新規作成時にtitleを入力しなかった場合にエラーが表示されること' do
      # 新規作成フォームにタイトルを入力しない
      fill_in 'Title', with: ''
      # Saveボタンをクリックする
      expect {
        click_button 'Save'
      }.to change(Blog, :count).by(0)
      # ブログ一覧画面に遷移したことを検証する
      expect(current_path).to eq blogs_path
      expect(page).to have_content "Title can't be blank"
    end
    scenario 'Blogの新規作成時にtitleを入力した場合はデータが保存され一覧画面に遷移すること' do
      # 新規作成フォームにタイトルを入力する
      fill_in 'Title', with: 'いぬがすき！わんわんブログ'
      # Saveボタンをクリックする
      expect {
        click_button 'Save'
      }.to change(Blog, :count).by(1)
      # ブログ一覧画面に遷移したことを検証する
      expect(current_path).to eq blogs_path
      expect(page).to have_content 'Blog was successfully created.'
    end
  end
  context '更新の場合' do
    background do
      # 更新ページを開く
      click_link 'Edit'
    end
    scenario 'Blogの更新時にtitleを空白にした場合にエラーが表示されること' do
      # 更新フォームにタイトルを入力しない
      fill_in 'Title', with: ''
      # Saveボタンをクリックする
      expect {
        click_button 'Save'
      }.to change(Blog, :count).by(0)
      # ブログ閲覧画面に遷移したことを検証する
      expect(current_path).to eq blog_path(@blog)
      expect(page).to have_content "Title can't be blank"
    end
    scenario 'Blogの更新時にtitleを入力した場合はデータが保存され閲覧画面に遷移すること' do
      # 更新フォームのタイトルを更新する
      fill_in 'Title', with: 'ねこがすき！にゃんにゃんブログ【改】'
      # Saveボタンをクリックする
      expect {
        click_button 'Save'
      }.to change(Blog, :count).by(0)
      # ブログ閲覧画面に遷移したことを検証する
      expect(current_path).to eq blog_path(@blog)
      expect(page).to have_content 'Blog was successfully updated.'
    end
  end
end
