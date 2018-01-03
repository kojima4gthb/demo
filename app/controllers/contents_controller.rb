class ContentsController < ApplicationController
  before_action :set_blog, only: [:show, :edit, :update, :destroy]

  def index
    if current_user == nil
      redirect_to top_path
    end
    @blogs = Blog.all
  end

  def tri
    # 以下のボタンが押された場合
    if params[:btn_tri_shape]
      # 三角形の形を求める
      @tri_shape = Triangle.triangle_shape(params[:tri_len0].to_i,
                                           params[:tri_len1].to_i,
                                           params[:tri_len2].to_i)
    else
      @tri_shape = ''
    end
  end

  def era
    # 以下のボタンが押された場合
    if params[:btn_prime_list]
      # 2~maxまでの配列を取得
      @prime_list = Eratosthenes.prime_number_list params[:era_max_num].to_i
    else
      @prime_list = []
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_blog
    @blog = Blog.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def blog_params
    params.require(:blog).permit(:title)
  end

end
