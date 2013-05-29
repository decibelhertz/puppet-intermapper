require 'spec_helper'

describe 'intermapper::datacenter', :type => 'class' do
  context "On a RedHat OS" do
    let :facts do
      {
        :osfamily => 'RedHat'
      }
    end

    it {
      should contain_package('intermapper-datacenter').with ( {
        'name' => 'InterMapper-DataCenter',
      } )
    }

  end

end
