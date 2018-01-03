require File.expand_path(File.dirname(__FILE__) + '/../../../app/controllers/concerns/eratosthenes')

describe Eratosthenes do
  specify { expect{Eratosthenes.prime_number_list(1)}.to raise_error(ArgumentError) }
  specify { expect(Eratosthenes.prime_number_list(2)).to eq [2] }
  specify { expect(Eratosthenes.prime_number_list(3)).to eq [2, 3] }
  specify { expect(Eratosthenes.prime_number_list(10)).to eq [2, 3, 5, 7] }
  specify { expect(Eratosthenes.prime_number_list(20)).to eq [2, 3, 5, 7, 11, 13, 17, 19] }
  specify { expect(Eratosthenes.prime_number_list(30)).to eq [2, 3, 5, 7, 11, 13, 17, 19, 23, 29] }
  specify { expect{Eratosthenes.prime_number_list(nil)}.to raise_error(ArgumentError) }
  specify { expect{Eratosthenes.prime_number_list('A')}.to raise_error(ArgumentError) }
  specify { expect{Eratosthenes.prime_number_list(1.1)}.to raise_error(ArgumentError) }
end
