require 'rails_helper'

describe Blog do
  it 'titleがあれば有効な状態であること' do
    blog = Blog.new(title: 'Blog')
    expect(blog.valid?).to be_truthy
  end

  it 'titleがなければ無効な状態であること' do
    blog = Blog.new(title: '')
    expect(blog.valid?).to be_falsey
    expect(blog.errors.full_messages[0]).to eq "Title can't be blank"
  end
end
