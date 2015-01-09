require 'spec_helper'

describe 'intermapper::service', :type => 'class' do

  context "On a RedHat OS" do
    let :facts do
      {
        :osfamily => 'RedHat'
      }
    end

    it {
      should contain_service('intermapperd').with( {
        'name' => 'intermapperd',
        'provider' => nil,
        'status' => nil,
      } )
    }
  end

  context "On a Solaris OS" do
    let :facts do
      {
        :osfamily => 'Solaris'
      }
    end

    it {
      should contain_service('intermapperd').with( {
        'name' => 'intermapperd',
        'provider' => 'init',
        'status' => '/usr/bin/pgrep intermapperd',
      } )
    }
  end

end
