require 'spec_helper'
describe 'nsd' do

  context 'with defaults for all parameters' do
    let(:facts) { {:concat_basedir => '/tmp'} }
    it { should contain_class('nsd') }
  end
end
