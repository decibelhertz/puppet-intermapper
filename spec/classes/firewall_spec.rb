require 'spec_helper' # frozen_string_literal: true

describe 'intermapper::firewall', type: :class do
  shared_context 'Supported Platform' do
    it do should_not compile end
    it do
      is_expected.to raise_error(
        Puppet::Error, /Use of private class intermapper::firewall by /
      )
    end
  end

  # See metadata.json
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end
      case facts[:os]['family']
      when 'Debian', 'RedHat' then
        include_context 'Supported Platform'
      end
    end
  end
end
