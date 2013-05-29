require 'spec_helper'

describe 'intermapper::install', :type => 'class' do
  context "On a RedHat OS" do
    let :facts do
      { :osfamily => 'RedHat',
      }
    end

    it {
      should contain_package('intermapper').with ( {
        'name' => 'intermapper',
      } )
    }

  end
end
