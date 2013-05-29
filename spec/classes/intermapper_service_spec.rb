require 'spec_helper'

describe 'intermapper::service', :type => 'class' do

  context "On a RedHat OS" do
    let :facts do
      {
        :osfamily => 'RedHat'
      }
    end

    it {
      should contain_service('intermapperd').with_name('intermapperd')
    }

  end

end
