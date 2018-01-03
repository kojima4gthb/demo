require 'rails_helper'

describe EntriesController do
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

  describe 'Get #show' do
    before do
      @blog = create(:blog, title: 'ねこがすき！にゃんにゃんブログ')
      @entry = @blog.entries.create(title: 'はじめてのエントリー', body: 'はじめまして！')
      @entry.comments.create(body: 'てすてす	')
      @entry.comments.create(body: 'ねこはかわいいですよね')
    end
    context '遷移元が正しい場合' do
      before do
        request.env['HTTP_REFERER'] = 'http://localhost:3000/blogs/1'
        get 'show', params: { id: @entry.id, blog_id: @blog.id }, session: { blog_title: @blog.title }
      end
      it '@entryに表示するEntryが入っていること' do
        expect(assigns(:entry)).to eq @entry
      end
      it 'session[:blog_title]に表示するタイトルが入っていること' do
        expect(session[:blog_title]).to eq @blog.title
      end
      it 'showテンプレートを表示すること' do
        expect(response).to render_template :show
      end
      it 'レスポンス200を返すこと'  do
        expect(response).to have_http_status(:ok)
      end
    end
    context '遷移元が親子以外の場合' do
      before do
        request.env['HTTP_REFERER'] = illegal_path_1
        get 'show', params: { id: @entry.id, blog_id: @blog.id }, session: { blog_title: @blog.title }
      end
      it_behaves_like 'to_root'
    end
    context '遷移元が不正な場合' do
      before do
        request.env['HTTP_REFERER'] = illegal_path_2
        get 'show', params: { id: @entry.id, blog_id: @blog.id }, session: { blog_title: @blog.title }
      end
      it_behaves_like 'to_root'
    end
  end

  describe 'Get #new' do
    before do
      @blog = create(:blog)
    end
    context '遷移元が正しい場合' do
      before do
        request.env['HTTP_REFERER'] = 'http://localhost:3000/blogs/1'
        get 'new', params: { blog_id: @blog.id }, session: { blog_title: @blog.title }
      end
      it '@entryが生成されていること' do
        expect(assigns(:entry)).to be_a_new Entry
      end
      it 'newテンプレートを表示すること' do
        expect(response).to render_template :new
      end
      it 'レスポンス200を返すこと'  do
        expect(response).to have_http_status(:ok)
      end
    end
    context '遷移元が親子以外の場合' do
      before do
        request.env['HTTP_REFERER'] = illegal_path_1
        get 'new', params: { blog_id: @blog.id }, session: { blog_title: @blog.title }
      end
      it_behaves_like 'to_root'
    end
    context '遷移元が不正な場合' do
      before do
        request.env['HTTP_REFERER'] = illegal_path_2
        get 'new', params: { blog_id: @blog.id }, session: { blog_title: @blog.title }
      end
      it_behaves_like 'to_root'
    end
  end

  describe 'Get #edit' do
    before do
      @blog = create(:blog)
      @entry = @blog.entries.create(title: 'はじめてのエントリー', body: 'はじめまして！')
    end
    context '遷移元が正しい場合' do
      before do
        request.env['HTTP_REFERER'] = 'http://localhost:3000/blogs/1/entries/1'
        get 'edit', params: { id: @entry.id, blog_id: @blog.id }, session: { blog_title: @blog.title }
      end
      it '@entryに更新するEntryが入っていること' do
        expect(assigns(:entry)).to eq @entry
      end
      it 'editテンプレートを表示すること' do
        expect(response).to render_template :edit
      end
      it 'レスポンス200を返すこと'  do
        expect(response).to have_http_status(:ok)
      end
    end
    context '遷移元が親子以外の場合' do
      before do
        request.env['HTTP_REFERER'] = illegal_path_1
        get 'edit', params: { id: @entry.id, blog_id: @blog.id }, session: { blog_title: @blog.title }
      end
      it_behaves_like 'to_root'
    end
    context '遷移元が不正な場合' do
      before do
        request.env['HTTP_REFERER'] = illegal_path_2
        get 'edit', params: { id: @entry.id, blog_id: @blog.id }, session: { blog_title: @blog.title }
      end
      it_behaves_like 'to_root'
    end
  end

  describe 'Post #create' do
    before do
      @blog = create(:blog)
      @entry_attributes = attributes_for(:entry, blog_id: @blog.id)
    end
    context '遷移元が正しい場合' do
      before do
        request.env['HTTP_REFERER'] = 'http://localhost:3000/blogs/1/entries/new'
      end
      it '新しいレコードが生成されること' do
        expect do
          post 'create', params: { entry: @entry_attributes, blog_id: @blog.id }, session: { blog_title: @blog.title }
        end.to change(Entry, :count).by(1)
      end
      it 'blogsのshowに遷移すること' do
        post 'create', params: { entry: @entry_attributes, blog_id: @blog.id }, session: { blog_title: @blog.title }
        expect(response).to redirect_to(blog_path(@blog))
      end
      it 'レスポンス302を返すこと'  do
        post 'create', params: { entry: @entry_attributes, blog_id: @blog.id }, session: { blog_title: @blog.title }
        expect(response).to have_http_status(:found)
      end
    end
    context '遷移元が親子以外の場合' do
      before do
        request.env['HTTP_REFERER'] = illegal_path_1
        post 'create', params: { entry: @entry_attributes, blog_id: @blog.id }, session: { blog_title: @blog.title }
      end
      it_behaves_like 'to_root'
    end
    context '遷移元が不正な場合' do
      before do
        request.env['HTTP_REFERER'] = illegal_path_2
        post 'create', params: { entry: @entry_attributes, blog_id: @blog.id }, session: { blog_title: @blog.title }
      end
      it_behaves_like 'to_root'
    end
  end

  describe 'Post #create 2' do
    describe 'タイトルなし' do
      before do
        @blog = create(:blog)
        @entry_attributes = attributes_for(:entry, blog_id: @blog.id, title: '')
      end
      context '遷移元が正しい場合' do
        before do
          request.env['HTTP_REFERER'] = 'http://localhost:3000/blogs/1/entries/new'
        end
        it '新しいレコードが生成されないこと' do
          expect do
            post 'create', params: { entry: @entry_attributes, blog_id: @blog.id }, session: { blog_title: @blog.title }
          end.to change(Entry, :count).by(0)
        end
        it 'blogsのindexに遷移すること' do
          post 'create', params: { entry: @entry_attributes, blog_id: @blog.id }, session: { blog_title: @blog.title }
          expect(response).to redirect_to(blog_path(@blog))
        end
        it 'レスポンス302を返すこと'  do
          post 'create', params: { entry: @entry_attributes, blog_id: @blog.id }, session: { blog_title: @blog.title }
          expect(response).to have_http_status(:found)
        end
      end
    end
  end

  describe 'PATCH #update' do
    before do
      @blog = create(:blog)
      @entry = create(:entry, blog_id: @blog.id)
      @entry_attributes = { title: 'update title', body: 'update body', blog_id: @blog.id }
    end
    context '遷移元が正しい場合' do
      before do
        request.env['HTTP_REFERER'] = 'http://localhost:3000/blogs/1/entries/1/edit'
      end
      it 'レコード数に変化がないこと' do
        expect do
          patch :update, params: { id: @entry.id, entry: @entry_attributes, blog_id: @blog.id }, session: { blog_title: @blog.title }
        end.to change(Entry, :count).by(0)
      end
      it 'titleが更新されること' do
        patch :update, params: { id: @entry.id, entry: @entry_attributes, blog_id: @blog.id }, session: { blog_title: @blog.title }
        @entry.reload
        expect(@entry.title).to eq @entry_attributes[:title]
      end
      it 'blogsのshowに遷移すること' do
        patch :update, params: { id: @entry.id, entry: @entry_attributes, blog_id: @blog.id }, session: { blog_title: @blog.title }
        expect(response).to redirect_to(blog_path(@blog))
      end
      it 'レスポンス302を返すこと'  do
        patch :update, params: { id: @entry.id, entry: @entry_attributes, blog_id: @blog.id }, session: { blog_title: @blog.title }
        expect(response).to have_http_status(:found)
      end
    end
    context '遷移元が親子以外の場合' do
      before do
        request.env['HTTP_REFERER'] = illegal_path_1
        patch :update, params: { id: @entry.id, entry: @entry_attributes, blog_id: @blog.id }, session: { blog_title: @blog.title }
      end
      it_behaves_like 'to_root'
    end
    context '遷移元が不正な場合' do
      before do
        request.env['HTTP_REFERER'] = illegal_path_2
        patch :update, params: { id: @entry.id, entry: @entry_attributes, blog_id: @blog.id }, session: { blog_title: @blog.title }
      end
      it_behaves_like 'to_root'
    end
  end

  describe 'PATCH #update 2' do
    describe 'タイトルなしで登録' do
      before do
        @blog = create(:blog)
        @entry = create(:entry, blog_id: @blog.id)
        @entry_attributes = { title: '', body: 'update body', blog_id: @blog.id }
      end
      context '遷移元が正しい場合' do
        before do
          request.env['HTTP_REFERER'] = 'http://localhost:3000/blogs/1/entries/1/edit'
        end
        it 'レコード数に変化がないこと' do
          expect do
            patch :update, params: { id: @entry.id, entry: @entry_attributes, blog_id: @blog.id }, session: { blog_title: @blog.title }
          end.to change(Entry, :count).by(0)
        end
        it 'titleが更新されないこと' do
          patch :update, params: { id: @entry.id, entry: @entry_attributes, blog_id: @blog.id }, session: { blog_title: @blog.title }
          tmp_entry = @entry
          @entry.reload
          expect(@entry.title).to eq tmp_entry.title
        end
        it 'blogsのshowに遷移すること' do
          patch :update, params: { id: @entry.id, entry: @entry_attributes, blog_id: @blog.id }, session: { blog_title: @blog.title }
          expect(response).to redirect_to(blog_path(@blog))
        end
        it 'レスポンス302を返すこと'  do
          patch :update, params: { id: @entry.id, entry: @entry_attributes, blog_id: @blog.id }, session: { blog_title: @blog.title }
          expect(response).to have_http_status(:found)
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    before do
      @blog = create(:blog)
      @entry = create(:entry, blog_id: @blog.id)
    end
    context '遷移元が正しい場合' do
      before do
        request.env['HTTP_REFERER'] = 'http://localhost:3000/blogs/1'
      end
      it 'レコードが削除されること' do
        expect do
          delete 'destroy', params: { id: @entry.id, blog_id: @blog.id }, session: { blog_title: @blog.title }
        end.to change(Entry, :count).by(-1)
      end
      it 'blogsのshowに遷移すること' do
        delete 'destroy', params: { id: @entry.id, blog_id: @blog.id }, session: { blog_title: @blog.title }
        expect(response).to redirect_to blog_path(@blog)
      end
      it 'レスポンス302を返すこと'  do
        delete 'destroy', params: { id: @entry.id, blog_id: @blog.id }, session: { blog_title: @blog.title }
        expect(response).to have_http_status(:found)
      end
    end
    context '遷移元が親子以外の場合' do
      before do
        request.env['HTTP_REFERER'] = illegal_path_1
        delete 'destroy', params: { id: @entry.id, blog_id: @blog.id }, session: { blog_title: @blog.title }
      end
      it_behaves_like 'to_root'
    end
    context '遷移元が不正な場合' do
      before do
        request.env['HTTP_REFERER'] = illegal_path_2
        delete 'destroy', params: { id: @entry.id, blog_id: @blog.id }, session: { blog_title: @blog.title }
      end
      it_behaves_like 'to_root'
    end
  end

end
