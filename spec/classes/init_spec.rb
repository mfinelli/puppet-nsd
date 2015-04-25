require 'spec_helper'
describe 'nsd' do

  context 'with defaults for all parameters' do
    it { should contain_class('nsd') }
  end
end
