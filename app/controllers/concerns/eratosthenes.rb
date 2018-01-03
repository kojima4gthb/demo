class Eratosthenes

  def self.prime_number_list(max)
    if !(max.kind_of?(Integer)) || (max < 2)
      raise ArgumentError, "max[#{max}]"
    end

    # 2~maxまでの配列を作成
    lists = (2..max).to_a

    # maxの平方根までループ
    2.upto(Math.sqrt(max)) do |num|
      # 素数の倍数を削除
      lists.reject! { |list|
        ((list % num).eql? 0) && (list > num)
      }
    end
    # 配列を返却
    lists
  end

end