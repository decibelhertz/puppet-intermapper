require 'spec_helper'

describe 'intermapper', :type => 'class' do

  it {
    should contain_class('intermapper::install')
  }
end
