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
      } )
    }
  end

end
