require 'spec_helper'

describe 'intermapper', :type => 'class' do

  it {
    should contain_class('intermapper::install')
    should contain_class('intermapper::service')
  }
end
