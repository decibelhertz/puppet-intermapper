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
        'source' => 'http://download.dartware.com/im568/InterMapper-5.6.8-1.i386.4x.rpm'
      } )
    }

  end
end
