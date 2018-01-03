require File.expand_path(File.dirname(__FILE__) + '/../../../app/controllers/concerns/triangle')

describe Triangle do
  # min - max
  specify { expect(Triangle.triangle_shape(1, 1, 1)).to eq '正三角形' }
  specify { expect(Triangle.triangle_shape(4611686018427387904,
                                           4611686018427387904,
                                           4611686018427387904)).to eq '正三角形' }
  # ３辺が最も短い長さで場合分け
  specify { expect{Triangle.triangle_shape(0, 1, 1)}.to raise_error(ArgumentError) }
  specify { expect{Triangle.triangle_shape(1, 0, 1)}.to raise_error(ArgumentError) }
  specify { expect{Triangle.triangle_shape(1, 1, 0)}.to raise_error(ArgumentError) }
  specify { expect(Triangle.triangle_shape(2, 3, 4)).to eq '不等辺三角形' }
  specify { expect(Triangle.triangle_shape(4, 2, 3)).to eq '不等辺三角形' }
  specify { expect(Triangle.triangle_shape(3, 4, 2)).to eq '不等辺三角形' }
  specify { expect(Triangle.triangle_shape(1, 2, 2)).to eq '二等辺三角形' }
  specify { expect(Triangle.triangle_shape(2, 1, 2)).to eq '二等辺三角形' }
  specify { expect(Triangle.triangle_shape(2, 2, 1)).to eq '二等辺三角形' }
  specify { expect(Triangle.triangle_shape(1, 2, 1)).to eq '非三角形' }
  specify { expect(Triangle.triangle_shape(1, 1, 2)).to eq '非三角形' }
  specify { expect(Triangle.triangle_shape(2, 1, 1)).to eq '非三角形' }
  specify { expect{Triangle.triangle_shape(nil, 1, 1)}.to raise_error(ArgumentError) }
  specify { expect{Triangle.triangle_shape(1, nil, 1)}.to raise_error(ArgumentError) }
  specify { expect{Triangle.triangle_shape(1, 1, nil)}.to raise_error(ArgumentError) }
  specify { expect{Triangle.triangle_shape('A', 1, 1)}.to raise_error(ArgumentError) }
  specify { expect{Triangle.triangle_shape(1, 'A', 1)}.to raise_error(ArgumentError) }
  specify { expect{Triangle.triangle_shape(1, 1, 'A')}.to raise_error(ArgumentError) }
  specify { expect{Triangle.triangle_shape(1.1, 1, 1)}.to raise_error(ArgumentError) }
  specify { expect{Triangle.triangle_shape(1, 1.1, 1)}.to raise_error(ArgumentError) }
  specify { expect{Triangle.triangle_shape(1, 1, 1.1)}.to raise_error(ArgumentError) }

  # 1,2,2 長い辺2本 <-> 2,2,3 短い辺2本
  specify { expect(Triangle.triangle_shape(1, 2, 2)).to eq '二等辺三角形' }
  specify { expect(Triangle.triangle_shape(2, 2, 3)).to eq '二等辺三角形' }
end
