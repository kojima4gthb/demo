require 'rails_helper'

feature 'Entry管理' do
  background do
    @blog = Blog.create!(title: 'ねこがすき！にゃんにゃんブログ')
    @blog.entries.create!(title: 'はじめてのエントリー', body: 'はじめまして！')
    visit blogs_path
    click_link 'Show'
  end
  context '新規作成の場合' do
    background do
      # 新規作成ページを開く
      click_link 'New Entry'
    end
    scenario 'Entryの新規作成時にtitleを入力しなかった場合にエラーが表示されること' do
      # 新規作成フォームにタイトルを入力しない
      fill_in 'Title', with: ''
      fill_in 'Body', with: 'おひさしぶりです！'
      # Saveボタンをクリックする
      expect {
        click_button 'Save'
      }.to change(Entry, :count).by(0)
      # ブログ閲覧画面に遷移したことを検証する
      expect(current_path).to eq blog_path(@blog)
      expect(page).to have_content "Title can't be blank"
    end
    scenario 'Entryの新規作成時にtitleを入力した場合はデータが保存され閲覧画面に遷移すること' do
      # 新規作成フォームにタイトルを入力する
      fill_in 'Title', with: '2番目のエントリー'
      fill_in 'Body', with: 'おひさしぶりです！'
      # Saveボタンをクリックする
      expect {
        click_button 'Save'
      }.to change(Entry, :count).by(1)
      # ブログ閲覧画面に遷移したことを検証する
      expect(current_path).to eq blog_path(@blog)
      expect(page).to have_content 'Entry was successfully created.'
    end
  end
  context '更新の場合' do
    background do
      # 更新ページを開く
      click_link 'Edit'
    end
    scenario 'Entryの更新時にtitleを空白にした場合にエラーが表示されること' do
      # 更新フォームにタイトルを入力しない
      fill_in 'Title', with: ''
      fill_in 'Body', with: 'おひさしぶりです！	'
      # Saveボタンをクリックする
      expect {
        click_button 'Save'
      }.to change(Entry, :count).by(0)
      # ブログ閲覧画面に遷移したことを検証する
      expect(current_path).to eq blog_path(@blog)
      expect(page).to have_content "Title can't be blank"
    end
    scenario 'Entryの更新時にtitleを入力した場合はデータが更新され閲覧画面に遷移すること' do
      # 更新フォームのタイトルを更新する
      fill_in 'Title', with: 'はじめてのエントリー【改】'
      fill_in 'Body', with: 'はじめまして！'
      # Saveボタンをクリックする
      expect {
        click_button 'Save'
      }.to change(Entry, :count).by(0)
      # ブログ閲覧画面に遷移したことを検証する
      expect(current_path).to eq blog_path(@blog)
      expect(page).to have_content 'Entry was successfully updated.'
    end
  end
end
