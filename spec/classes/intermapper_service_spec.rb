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

  context "On a Solaris OS" do
    let :facts do
      {
        :osfamily => 'Solaris'
      }
    end

    it {
      should contain_service('intermapperd').with_name(
        'lrc:/etc/rc3_d/S99intermapperd')
    }
  end

end
