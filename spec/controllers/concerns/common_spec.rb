require 'rails_helper'

describe Common do
  let(:test_class) { Struct.new(:common) { include Common } }
  let(:common) { test_class.new }

  describe '.get_alphabet' do
    specify { expect(common.get_alphabet(-1)).to eq 'z' }
    specify { expect(common.get_alphabet(0)).to eq 'a' }
    specify { expect(common.get_alphabet(25)).to eq 'z' }
    specify { expect(common.get_alphabet(26)).to eq '26' }
    specify { expect(common.get_alphabet(100)).to eq '100' }
  end

end
