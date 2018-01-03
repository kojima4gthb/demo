class Triangle

  # 三角形の形を出力して返却する.
  def self.triangle_shape(len0, len1, len2)
    [len0, len1, len2].each do |len|
        if !(len.kind_of?(Integer)) || (len < 1)
          raise ArgumentError, "length[#{len}]"
        end
    end

    # 昇順に並べる.
    arr = Array.new([len0, len1, len2]).sort

    # 最大長の辺 ＜ それ以外の辺の和 なら三角形となる.
    if arr[2] < (arr[0] + arr[1])
      if arr[0].eql?(arr[1]) && arr[1].eql?(arr[2])
        puts '正三角形ですね！'
        '正三角形'
      elsif arr[0].eql?(arr[1]) || arr[1].eql?(arr[2]) || arr[2].eql?(arr[0])
        puts '二等辺三角形ですね！'
        '二等辺三角形'
      else
        puts '不等辺三角形ですね！'
        '不等辺三角形'
      end
    else
      puts '三角形じゃないです＞＜'
      '非三角形'
    end
  end

end

# Triangle.triangle_shape(ARGV[0].to_i,
#                         ARGV[1].to_i,
#                         ARGV[2].to_i)
