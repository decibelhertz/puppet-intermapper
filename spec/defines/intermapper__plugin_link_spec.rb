require 'spec_helper'

describe 'intermapper::nagios_plugin_link', :type => :define do
  npd='/usr/lib64/nagios-plugins'
  t='my_nagios_plugin'
  baseparams = {
    'nagios_plugins_dir' => npd,
  }
  let(:title) { t }
  targetfname="#{npd}/#{t}"
  fname="/var/local/InterMapper_Settings/Tools/#{t}"

  ['CentOS', 'RedHat', 'Solaris'].each do |system|
    context "when on system #{system}" do
      let(:params) {baseparams}
      if system == 'CentOS'
        let(:facts) {{
          :osfamily        => 'RedHat',
          :operatingsystem => system,
        }}
      else
        let(:facts) {{
          :osfamily        => system,
          :operatingsystem => system,
        }}
      end

      describe 'with defaults' do
        it { should contain_file(fname
                                ).that_notifies('Class[intermapper::service]') }
      end

      {
        :present => [:link, targetfname],
        :link    => [:link, targetfname],
        :absent  => [:absent, nil],
        :missing => [:absent, nil],
      }.each do |k,v|
        context "with ensure == #{k}" do
          let(:params) {
            super().merge({:ensure      => "#{k}"})
          }
          it do
            should contain_file(fname).with({
              :ensure => v[0],
              :target => v[1],
            })
          end
        end
      end
    end # context when on system
  end # system each
end
