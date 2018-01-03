require 'rails_helper'

describe Entry do
  context '親のentryがある場合' do
    let(:blog) { Blog.new(title: 'Blog') }
    let(:entry) { blog.entries.new(title: 'Entry') }

    it 'bodyがあれば有効な状態であること' do
      comment = entry.comments.new(body: 'Comment')
      expect(comment.valid?).to be_truthy
    end
    it 'bodyがなければ無効な状態であること' do
      comment = entry.comments.new(body: '')
      expect(comment.valid?).to be_falsey
      expect(comment.errors.full_messages[0]).to eq "Body can't be blank"
    end
  end

  context '親のentryがない場合' do
    it 'bodyが『あっても』無効な状態であること' do
      comment = Comment.new(body: 'Comment')
      expect(comment.valid?).to be_falsey
      expect(comment.errors.full_messages[0]).to eq 'Entry must exist'
    end
    it 'bodyがなければ無効な状態であること' do
      comment = Comment.new(body: '')
      expect(comment.valid?).to be_falsey
      expect(comment.errors.full_messages[0]).to eq 'Entry must exist'
    end
  end
end
