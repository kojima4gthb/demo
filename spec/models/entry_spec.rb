require 'rails_helper'

describe Entry do
  context '親のblogがある場合' do
    let(:blog) { Blog.new(title: 'Blog') }

    it 'titleがあれば有効な状態であること' do
        entry = blog.entries.new(title: 'Entry')
        expect(entry.valid?).to be_truthy
    end
    it 'titleがなければ無効な状態であること' do
        entry = blog.entries.new(title: '')
        expect(entry.valid?).to be_falsey
        expect(entry.errors.full_messages[0]).to eq "Title can't be blank"
      end
    end

  context '親のblogがない場合' do
    it 'titleが『あっても』無効な状態であること' do
      entry = Entry.new(title: 'Entry')
      expect(entry.valid?).to be_falsey
      expect(entry.errors.full_messages[0]).to eq 'Blog must exist'
    end
    it 'titleがなければ無効な状態であること' do
      entry = Entry.new(title: '')
      expect(entry.valid?).to be_falsey
      expect(entry.errors.full_messages[0]).to eq 'Blog must exist'
    end
  end
end
