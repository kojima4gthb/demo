require 'rails_helper'

describe BlogsController do
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

  describe 'Get #index' do
    before do
      @blogs = [create(:blog, title: 'ねこがすき！にゃんにゃんブログ'),
                create(:blog, title: 'いぬがすき！わんわんブログ'),
                create(:blog, title: 'つまがすき！いとうさんブログ')]
      get 'index', params: {}, session: {}
    end
    it '@blogsに全てのBlogが入っていること' do
      expect(assigns(:blogs)).to match_array(@blogs)
    end
    it 'indexテンプレートを表示すること' do
      expect(response).to render_template :index
    end
    it 'レスポンス200を返すこと'  do
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'Get #show' do
    before do
      @blog = create(:blog)
      @blog.entries.create(title: 'はじめてのエントリー', body: 'はじめまして！')
      @blog.entries.create(title: '2番目のエントリー', body: 'おひさしぶりです！')
    end
    context '遷移元が正しい場合' do
      before do
        request.env['HTTP_REFERER'] = 'http://localhost:3000/blogs'
        get 'show', params: { id: @blog.id }, session: {}
      end
      it '@blogに表示するBlogが入っていること' do
        expect(assigns(:blog)).to eq @blog
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
        get 'show', params: { id: @blog.id }, session: {}
      end
      it_behaves_like 'to_root'
    end
    context '遷移元が不正な場合' do
      before do
        request.env['HTTP_REFERER'] = illegal_path_2
        get 'show', params: { id: @blog.id }, session: {}
      end
      it_behaves_like 'to_root'
    end
  end

  describe 'Get #new' do
    context '遷移元が正しい場合' do
      before do
        request.env['HTTP_REFERER'] = 'http://localhost:3000/blogs'
        get 'new', params: {}, session: {}
      end
      it '@blogが生成されていること' do
        expect(assigns(:blog)).to be_a_new Blog
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
        get 'new', params: {}, session: {}
      end
      it_behaves_like 'to_root'
    end
    context '遷移元が不正な場合' do
      before do
        request.env['HTTP_REFERER'] = illegal_path_2
        get 'new', params: {}, session: {}
      end
      it_behaves_like 'to_root'
    end
  end

  describe 'Get #edit' do
    before do
      @blog = create(:blog)
    end
    context '遷移元が正しい場合' do
      before do
        request.env['HTTP_REFERER'] = 'http://localhost:3000/blogs/1'
        get 'edit', params: { id: @blog.id}, session: {}
      end
      it '@blogに更新するBlogが入っていること' do
        expect(assigns(:blog)).to eq @blog
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
        get 'edit', params: { id: @blog.id}, session: {}
      end
      it_behaves_like 'to_root'
    end
    context '遷移元が不正な場合' do
      before do
        request.env['HTTP_REFERER'] = illegal_path_2
        get 'edit', params: { id: @blog.id}, session: {}
      end
      it_behaves_like 'to_root'
    end
  end

  describe 'Post #create' do
    before do
      @blog_attributes = attributes_for(:blog)
    end
    context '遷移元が正しい場合' do
      before do
        request.env['HTTP_REFERER'] = 'http://localhost:3000/blogs/new'
      end
      it '新しいレコードが生成されること' do
        expect do
          post 'create', params: { blog: @blog_attributes }, session: {}
        end.to change(Blog, :count).by(1)
      end
      it 'blogsのindexに遷移すること' do
        post 'create', params: { blog: @blog_attributes }, session: {}
        expect(response).to redirect_to(blogs_path)
      end
      it 'レスポンス302を返すこと'  do
        post 'create', params: { blog: @blog_attributes }, session: {}
        expect(response).to have_http_status(:found)
      end
    end
    context '遷移元が親子以外の場合' do
      before do
        request.env['HTTP_REFERER'] = illegal_path_1
        post 'create', params: { blog: @blog_attributes }, session: {}
      end
      it_behaves_like 'to_root'
    end
    context '遷移元が不正な場合' do
      before do
        request.env['HTTP_REFERER'] = illegal_path_2
        post 'create', params: { blog: @blog_attributes }, session: {}
      end
      it_behaves_like 'to_root'
    end
  end

  describe 'Post #create 2' do
    describe 'タイトルなし' do
      before do
        @blog_attributes = { title: ''}
      end
      context '遷移元が正しい場合' do
        before do
          request.env['HTTP_REFERER'] = 'http://localhost:3000/blogs/new'
        end
        it '新しいレコードが生成されないこと' do
          expect do
            post 'create', params: { blog: @blog_attributes }, session: {}
          end.to change(Blog, :count).by(0)
        end
        it 'blogsのindexに遷移すること' do
          post 'create', params: { blog: @blog_attributes }, session: {}
          expect(response).to redirect_to blogs_path
        end
        it 'レスポンス302を返すこと'  do
          post 'create', params: { blog: @blog_attributes }, session: {}
          expect(response).to have_http_status(:found)
        end
      end
    end
  end

  describe 'PATCH #update' do
    before do
      @blog = create(:blog)
      @blog_attributes = { title: 'update title' }
    end
    context '遷移元が正しい場合' do
      before do
        request.env['HTTP_REFERER'] = 'http://localhost:3000/blogs/1/edit'
      end
      it 'レコード数に変化がないこと' do
        expect do
          patch :update, params: { id: @blog.id, blog: @blog_attributes }, session: {}
        end.to change(Blog, :count).by(0)
      end
      it 'titleが更新されること' do
        patch :update, params: { id: @blog.id, blog: @blog_attributes }, session: {}
        @blog.reload
        expect(@blog.title).to eq @blog_attributes[:title]
      end
      it 'blogsのindexに遷移すること' do
        patch :update, params: { id: @blog.id, blog: @blog_attributes }, session: {}
        blog = Blog.last
        expect(response).to redirect_to(blogs_path)
      end
      it 'レスポンス302を返すこと'  do
        patch :update, params: { id: @blog.id, blog: @blog_attributes }, session: {}
        expect(response).to have_http_status(:found)
      end
    end
    context '遷移元が親子以外の場合' do
      before do
        request.env['HTTP_REFERER'] = illegal_path_1
        patch :update, params: { id: @blog.id, blog: @blog_attributes }, session: {}
      end
      it_behaves_like 'to_root'
    end
    context '遷移元が不正な場合' do
      before do
        request.env['HTTP_REFERER'] = illegal_path_2
        patch :update, params: { id: @blog.id, blog: @blog_attributes }, session: {}
      end
      it_behaves_like 'to_root'
    end
  end

  describe 'PATCH #update 2' do
    describe 'タイトルなしで更新' do
      before do
        @blog = create(:blog)
        @blog_attributes = { title: '' }
      end
      context '遷移元が正しい場合' do
        before do
          request.env['HTTP_REFERER'] = 'http://localhost:3000/blogs/1/edit'
        end
        it 'レコード数に変化がないこと' do
          expect do
            patch :update, params: { id: @blog.id, blog: @blog_attributes }, session: {}
          end.to change(Blog, :count).by(0)
        end
        it 'titleが更新されないこと' do
          patch :update, params: { id: @blog.id, blog: @blog_attributes }, session: {}
          tmp_blog = @blog
          @blog.reload
          expect(@blog.title).to eq tmp_blog.title
        end
        it 'blogsのshowに遷移すること' do
          patch :update, params: { id: @blog.id, blog: @blog_attributes }, session: {}
          blog = Blog.last
          expect(response).to redirect_to(blogs_path)
        end
        it 'レスポンス302を返すこと'  do
          patch :update, params: { id: @blog.id, blog: @blog_attributes }, session: {}
          expect(response).to have_http_status(:found)
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    before do
      @blog = create(:blog)
    end
    context '遷移元が正しい場合' do
      before do
        request.env['HTTP_REFERER'] = 'http://localhost:3000/blogs'
      end
      it 'レコードが削除されること' do
        expect do
          delete 'destroy', params: { id: @blog.id }, session: {}
        end.to change(Blog, :count).by(-1)
      end
      it 'blogsのindexに遷移すること' do
        delete 'destroy', params: { id: @blog.id }, session: {}
        expect(response).to redirect_to blogs_path
      end
      it 'レスポンス302を返すこと'  do
        delete 'destroy', params: { id: @blog.id }, session: {}
        expect(response).to have_http_status(:found)
      end
    end
    context '遷移元が親子以外の場合' do
      before do
        request.env['HTTP_REFERER'] = illegal_path_1
        delete 'destroy', params: { id: @blog.id }, session: {}
      end
      it_behaves_like 'to_root'
    end
    context '遷移元が不正な場合' do
      before do
        request.env['HTTP_REFERER'] = illegal_path_2
        delete 'destroy', params: { id: @blog.id }, session: {}
      end
      it_behaves_like 'to_root'
    end
  end

end
