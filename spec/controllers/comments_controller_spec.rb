require 'rails_helper'

describe CommentsController do
  shared_examples_for 'to_root' do
    it 'blogsのindexに遷移すること' do
      expect(response).to redirect_to blogs_path
    end
    it 'レスポンス302を返すこと'  do
      expect(response).to have_http_status(:found)
    end
  end

  let(:illegal_path_1) { 'http://localhost:3000/top' }
  let(:illegal_path_2) { 'http://test.co.jp' }

  describe 'Post #create' do
    before do
      @blog = create(:blog)
      @entry = @blog.entries.create( title: 'create title', body: 'create body', blog_id: @blog.id )
      @comment_attributes = attributes_for(:comment, entry_id: @entry.id)
    end
    context '遷移元が正しい場合' do
      before do
        request.env['HTTP_REFERER'] = 'http://localhost:3000/blogs/1/entries/1'
      end
      it '新しいレコードが生成されること' do
        expect do
          post 'create', params: { comment: @comment_attributes, entry_id: @entry.id, blog_id: @blog.id }, session: { blog_title: @blog.title }
        end.to change(Comment, :count).by(1)
      end
      it 'entriesのshowに遷移すること' do
        post 'create', params: { comment: @comment_attributes, entry_id: @entry.id, blog_id: @blog.id }, session: { blog_title: @blog.title }
        expect(response).to redirect_to(blog_entry_path(@blog, @entry))
      end
      it 'レスポンス302を返すこと'  do
        post 'create', params: { comment: @comment_attributes, entry_id: @entry.id, blog_id: @blog.id }, session: { blog_title: @blog.title }
        expect(response).to have_http_status(:found)
      end
    end
    context '遷移元が親子以外の場合' do
      before do
        request.env['HTTP_REFERER'] = illegal_path_1
        post 'create', params: { comment: @comment_attributes, entry_id: @entry.id, blog_id: @blog.id }, session: { blog_title: @blog.title }
      end
      it_behaves_like 'to_root'
    end
    context '遷移元が不正な場合' do
      before do
        request.env['HTTP_REFERER'] = illegal_path_2
        post 'create', params: { comment: @comment_attributes, entry_id: @entry.id, blog_id: @blog.id }, session: { blog_title: @blog.title }
      end
      it_behaves_like 'to_root'
    end
  end

  describe 'Post #create 2' do
    describe 'タイトルなし' do
      before do
        @blog = create(:blog)
        @entry = create(:entry, blog_id: @blog.id)
        @comment_attributes = attributes_for(:comment, body: '', entry_id: @entry.id)
      end
      context '遷移元が正しい場合' do
        before do
          request.env['HTTP_REFERER'] = 'http://localhost:3000/blogs/1/entries/1'
        end
        it '新しいレコードが生成されないこと' do
          expect do
            post 'create', params: { comment: @comment_attributes, entry_id: @entry.id, blog_id: @blog.id }, session: { blog_title: @blog.title }
          end.to change(Comment, :count).by(0)
        end
        it 'entriesのindexに遷移すること' do
          post 'create', params: { comment: @comment_attributes, entry_id: @entry.id, blog_id: @blog.id }, session: { blog_title: @blog.title }
          expect(response).to redirect_to(blog_entry_path(@blog, @entry))
        end
        it 'レスポンス302を返すこと'  do
          post 'create', params: { comment: @comment_attributes, entry_id: @entry.id, blog_id: @blog.id }, session: { blog_title: @blog.title }
          expect(response).to have_http_status(:found)
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    before do
      @blog = create(:blog)
      @entry = create(:entry, blog_id: @blog.id)
      @comment = create(:comment, entry_id: @entry.id)
    end
    context '遷移元が正しい場合' do
      before do
        request.env['HTTP_REFERER'] = 'http://localhost:3000/blogs/1/entries/1'
      end
      it 'レコードが削除されること' do
        expect do
          delete 'destroy', params: { id: @comment.id, entry_id: @entry.id, blog_id: @blog.id }, session: { blog_title: @blog.title }
        end.to change(Comment, :count).by(-1)
      end
      it 'blogsのshowに遷移すること' do
        delete 'destroy', params: { id: @comment.id, entry_id: @entry.id, blog_id: @blog.id }, session: { blog_title: @blog.title }
        expect(response).to redirect_to(blog_entry_path(@blog, @entry))
      end
      it 'レスポンス302を返すこと'  do
        delete 'destroy', params: { id: @comment.id, entry_id: @entry.id, blog_id: @blog.id }, session: { blog_title: @blog.title }
        expect(response).to have_http_status(:found)
      end
    end
    context '遷移元が親子以外の場合' do
      before do
        request.env['HTTP_REFERER'] = illegal_path_1
        delete 'destroy', params: { id: @comment.id, entry_id: @entry.id, blog_id: @blog.id }, session: { blog_title: @blog.title }
      end
      it_behaves_like 'to_root'
    end
    context '遷移元が不正な場合' do
      before do
        request.env['HTTP_REFERER'] = illegal_path_2
        delete 'destroy', params: { id: @comment.id, entry_id: @entry.id, blog_id: @blog.id }, session: { blog_title: @blog.title }
      end
      it_behaves_like 'to_root'
    end
  end

  describe 'PATCH #approve' do
    before do
      @blog = create(:blog)
      @entry = create(:entry, blog_id: @blog.id)
      @comment = create(:comment, entry_id: @entry.id)
      @comment_attributes = attributes_for(:comment, body: @comment.body, status: 'approved', entry_id: @entry.id)
    end
    context '遷移元が正しい場合' do
      before do
        request.env['HTTP_REFERER'] = 'http://localhost:3000/blogs/1/entries/1'
      end
      it 'レコード数に変化がないこと' do
        expect do
          patch :approve, params: { id: @comment.id, comment: @comment_attribute, entry_id: @entry.id, blog_id: @blog.id }, session: { blog_title: @blog.title }
        end.to change(Comment, :count).by(0)
      end
      it 'statusが更新されること' do
        patch :approve, params: { id: @comment.id, comment: @comment_attribute, entry_id: @entry.id, blog_id: @blog.id }, session: { blog_title: @blog.title }
        @comment.reload
        expect(@comment.status).to eq @comment_attributes[:status]
      end
      it 'entriesのshowに遷移すること' do
        patch :approve, params: { id: @comment.id, comment: @comment_attribute, entry_id: @entry.id, blog_id: @blog.id }, session: { blog_title: @blog.title }
        expect(response).to redirect_to(blog_entry_path(@blog, @entry))
      end
      it 'レスポンス302を返すこと'  do
        patch :approve, params: { id: @comment.id, comment: @comment_attribute, entry_id: @entry.id, blog_id: @blog.id }, session: { blog_title: @blog.title }
        expect(response).to have_http_status(:found)
      end
    end
    context '遷移元が親子以外の場合' do
      before do
        request.env['HTTP_REFERER'] = illegal_path_1
        patch :approve, params: { id: @comment.id, comment: @comment_attribute, entry_id: @entry.id, blog_id: @blog.id }, session: { blog_title: @blog.title }
      end
      it_behaves_like 'to_root'
    end
    context '遷移元が不正な場合' do
      before do
        request.env['HTTP_REFERER'] = illegal_path_2
        patch :approve, params: { id: @comment.id, comment: @comment_attribute, entry_id: @entry.id, blog_id: @blog.id }, session: { blog_title: @blog.title }
      end
      it_behaves_like 'to_root'
    end
  end

end
