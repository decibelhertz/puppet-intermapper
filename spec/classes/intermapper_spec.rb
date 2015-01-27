require 'spec_helper'

describe 'intermapper', :type => 'class' do

  ['CentOS', 'RedHat', 'Solaris'].each do |system|
    context "when on system #{system}" do
      if system == 'CentOS'
        let(:facts) do
          {
            :osfamily        => 'RedHat',
            :operatingsystem => system,
          }
        end
      else
        let(:facts) do
          {
            :osfamily        => system,
            :operatingsystem => system,
          }
        end
      end

      it { should contain_class('intermapper::install') }
      it { should contain_class('intermapper::nagios') }
      it { should contain_class('intermapper::service') }

      describe 'intermapper::install' do
        let(:params) {{
          :package_ensure => 'present',
          :package_name   => 'intermapper',
          :package_manage => true,
        }}
        it { should contain_package('intermapper').with_ensure('present') }

        describe 'should allow package ensure to be overridden' do
          let(:params) {{
            :package_ensure => 'latest',
            :package_name   => 'intermapper',
          }}
          it { should contain_package('intermapper').with_ensure('latest') }
        end

        describe 'should allow the package name to be overridden' do
          let(:params) {{
            :package_name => 'foo',
          }}
          it { should contain_package('foo') }
        end

        describe 'should allow the package name to be an array of names' do
          let(:params) {{
            :package_name => ['foo', 'bar'],
          }}
          it { should contain_package('foo') }
          it { should contain_package('bar') }
        end

        describe 'should allow the package to be unmanaged' do
          let(:params) {{
            :package_name   => 'intermapper',
            :package_manage => false,
          }}
          it { should_not contain_package('intermapper') }
        end

        describe 'should allow the provider to be overridden' do
          let(:params) {{
            :package_name     => 'intermapper',
            :package_provider => 'somethingcool',
          }}
          it { should contain_package('intermapper').with_provider(
            'somethingcool') }
        end
      end # describe intermapper::install

      describe 'intermapper::service' do
        let(:params) {{
          :service_name => 'intermapperd',
        }}
        describe 'with defaults' do
          it { should contain_service('intermapperd').with({
            :hasstatus => true,
            :ensure    => 'running',
          }) }
        end

        describe 'service_manage when false' do
          let(:params) {{
            :service_name   => 'intermapperd',
            :service_manage => false,
          }}
          it { should_not contain_service('intermapperd') }
        end

        describe 'service_ensure when overridden' do
          let(:params) {{
            :service_name   => 'intermapperd',
            :service_ensure => 'stopped',
          }}
          it { should contain_service('intermapperd').with_ensure('stopped') }
        end
      end # describe intermapper::service

      describe 'intermapper::nagios' do
        describe 'with defaults' do
          it {
            should_not contain_intermapper__nagios_plugin_link('check_nrpe')
          }
        end
        describe 'nagios_manage' do
          describe 'when true' do
            describe 'with nagios_ensure == present and plugins dir UNSET' do
              let(:params) {{
                :nagios_manage => true,
                :nagios_ensure => 'present',
              }}
              it { expect { should compile }.to raise_error(
                Puppet::Error, /must be specified/)
              }
            end

            describe 'with nagios_ensure == present and plugins dir set' do
              let(:params) {{
                :nagios_manage      => true,
                :nagios_ensure      => 'present',
                :nagios_plugins_dir => '/usr/lib64/nagios-plugins',
              }}
              # This is a subset of the defaults in intermapper::params
              ['check_nrpe', 'check_disk', 'check_file_age'].each do |nplugin|
                it {
                  should contain_intermapper__nagios_plugin_link(nplugin).with({
                    :ensure             => 'present',
                    :nagios_plugins_dir => '/usr/lib64/nagios-plugins',
                  })
                }
              end
            end

            describe 'when nagios_ensure == absent' do
              let(:params) {{
                :nagios_manage => true,
                :nagios_ensure => 'absent',
              }}
              ['check_nrpe', 'check_disk', 'check_file_age'].each do |nplugin|
                it {
                  should contain_intermapper__nagios_plugin_link(nplugin).with({
                    :ensure             => 'absent',
                    :nagios_plugins_dir => nil,
                  })
                }
              end

            end

          end # describe when_true
        end # describe nagios_manage

        describe 'nagios_link_plugins' do
          describe 'should allow overrides' do
            pnames = ['foo','bar','baz']
            let(:params) {{
              :nagios_manage       => true,
              :nagios_plugins_dir  => '/usr/lib64/nagios-plugins',
              :nagios_link_plugins => pnames,
            }}
            pnames.each do |p|
              it { should contain_intermapper__nagios_plugin_link(p) }
            end
          end
        end # describe nagios_link_plugins

      end # describe intermapper::nagios

    end # when on system
  end # os each block

  # OS-specific behavior driven by defaults starts here
  context 'default driven behavior' do
    context 'on Solaris' do
      let(:facts) { {
        :osfamily        => 'solaris',
        :operatingsystem => 'solaris',
      } }

      describe 'intermapper::install' do
        it { should contain_package('DARTinter').with({
          :provider => 'sun',
        })}
      end

      describe 'intermapper::service' do
        it { should contain_service('intermapperd').with({
          :provider => 'init',
          :status  => '/usr/bin/pgrep intermapperd',
        }) }
      end
    end

    context 'on RedHat osfamily' do
      ['RedHat','CentOS'].each do |osname|
        context "with operatingsystem == #{osname}" do
          let(:facts) {{
            :osfamily        => 'RedHat',
            :operatingsystem => osname,
          }}

          describe 'intermapper::service' do
            it { should contain_service('intermapperd').with({
              :provider => nil,
              :status   => nil,
            }) }
          end
        end
      end
    end
  end
end
