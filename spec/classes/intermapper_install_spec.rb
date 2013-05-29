require 'spec_helper'

describe 'intermapper::install', :type => 'class' do
  context "On a RedHat OS" do
    let :facts do
      {
        :osfamily => 'RedHat',
      }
    end

    it {
      should contain_package('intermapper').with ( {
        'name' => 'InterMapper',
        'provider' => nil,
      } )
    }

  end

  context "On a Solaris OS" do
    let :facts do
      {
        :osfamily => 'Solaris',
      }
    end

    it {
      should contain_package('intermapper').with ( {
        'name' => 'DARTinter',
        'provider' => 'sun',
      } )
    }
  end
end
