require 'spec_helper' # frozen_string_literal: true

describe 'intermapper::firewall', type: :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      it do is_expected.not_to compile end
      it do
        is_expected.to raise_error(
          Puppet::Error, %r{Use of private class intermapper::firewall by }
        )
      end
    end
  end
end
