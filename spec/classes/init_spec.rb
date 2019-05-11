require 'spec_helper' # frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
describe 'intermapper', type: :class do
  shared_context 'Supported Platform' do
    it do should contain_class('intermapper::install') end
    it do should contain_class('intermapper::config') end
    it do should contain_class('intermapper::nagios') end
    it do should contain_class('intermapper::service') end
    it do should contain_class('intermapper::service_extra') end

    describe 'intermapper::install' do
      let :params do
        {
          package_ensure: 'present',
          package_name: 'intermapper',
          package_manage: true
        }
      end
      it do should contain_package('intermapper').with_ensure('present') end

      describe 'should allow package ensure to be overridden' do
        let :params do
          { package_ensure: 'latest', package_name: 'intermapper' }
        end
        it do should contain_package('intermapper').with_ensure('latest') end
      end

      describe 'should allow the package name to be overridden' do
        let :params do
          { package_name: 'foo' }
        end
        it do should contain_package('foo') end
      end

      describe 'should allow the package name to be an array of names' do
        let :params do
          { package_name: %w[foo bar] }
        end
        it do should contain_package('foo') end
        it do should contain_package('bar') end
      end

      describe 'should allow the package to be unmanaged' do
        let :params do
          { package_name: 'intermapper', package_manage: false }
        end
        it do should_not contain_package('intermapper') end
      end

      describe 'should allow the provider to be overridden' do
        let :params do
          { package_name: 'intermapper', package_provider: 'somethingcool' }
        end
        it do
          should contain_package('intermapper').with_provider('somethingcool')
        end
      end
    end
    # describe intermapper::install

    describe 'intermapper::service' do
      let :params do
        { service_name: 'intermapperd' }
      end
      describe 'with defaults' do
        it do
          should contain_service('intermapperd').with(
            ensure: 'running',
            enable: true,
            hasstatus: true
          )
        end
      end

      describe 'service_manage when false' do
        let :params do
          { service_name: 'intermapperd', service_manage: false }
        end
        it do should_not contain_service('intermapperd') end
      end

      describe 'service_ensure when overridden' do
        let :params do
          { service_name: 'intermapperd', service_ensure: 'stopped' }
        end
        it do
          should contain_service('intermapperd').with(
            ensure: 'stopped',
            enable: false
          )
        end
      end
    end
    # describe intermapper::service

    describe 'intermapper::service_extra' do
      let :params do
        { service_imdc_name: 'imdc', service_imflows_name: 'imflows' }
      end
      describe 'with defaults' do
        it do
          should contain_service('imdc').with(
            ensure: 'stopped',
            enable: false,
            hasstatus: true
          )
        end
        it do
          should contain_service('imflows').with(
            ensure: 'stopped',
            enable: false,
            hasstatus: true
          )
        end
      end

      describe 'service_manage' do
        describe 'when false' do
          let :params do
            super().merge(service_manage: false)
          end
          it do should_not contain_service('imdc') end
          it do should_not contain_service('imflows') end

          describe 'and extra services manage is true' do
            let :params do
              super().merge(
                service_imdc_manage: true, service_imflows_manage: true
              )
            end
            it do should_not contain_service('imdc') end
            it do should_not contain_service('imflows') end
          end
        end

        describe 'when true' do
          let :params do
            super().merge(service_manage: true)
          end
          describe 'and extra services manage is false' do
            let :params do
              super().merge(
                service_imdc_manage: false, service_imflows_manage: false
              )
            end
            it do should_not contain_service('imdc') end
            it do should_not contain_service('imflows') end
          end

          describe 'and extra services manage is true' do
            let :params do
              super().merge(
                service_imdc_manage: true, service_imflows_manage: true
              )
            end
            it do should contain_service('imdc') end
            it do should contain_service('imflows') end
          end
        end
      end

      describe 'service_imdc_ensure when overridden' do
        let :params do
          super().merge(service_imdc_ensure: 'running')
        end
        it do
          should contain_service('imdc').with(ensure: 'running', enable: true)
        end
      end

      describe 'service_imflows_ensure when overridden' do
        let :params do
          super().merge(service_imflows_ensure: 'running')
        end
        it do
          should contain_service(
            'imflows'
          ).with(ensure: 'running', enable: true)
        end
      end
    end
    # describe intermapper::service_extra

    describe 'intermapper::nagios' do
      describe 'with defaults' do
        it do
          should_not contain_intermapper__nagios_plugin_link('check_nrpe')
        end
      end

      describe 'nagios_manage' do
        describe 'when true' do
          describe 'with nagios_ensure == present and plugins dir UNSET' do
            let :params do
              {
                nagios_ensure: 'present',
                nagios_manage: true,
                nagios_plugins_dir: 'UNSET'
              }
            end
            it do should raise_error(Puppet::Error, /must be specified/) end
          end

          describe 'with nagios_ensure == present and plugins dir set' do
            let :params do
              {
                nagios_ensure: 'present',
                nagios_manage: true,
                nagios_plugins_dir: '/usr/lib64/nagios-plugins'
              }
            end
            # This is a subset of the defaults in intermapper::params
            %w[check_nrpe check_disk check_file_age].each do |nplugin|
              it do
                should contain_intermapper__nagios_plugin_link(nplugin).with(
                  ensure: 'link',
                  nagios_plugins_dir: '/usr/lib64/nagios-plugins'
                )
              end
            end
          end

          describe 'when nagios_ensure == absent' do
            let :params do
              { nagios_manage: true, nagios_ensure: 'absent' }
            end
            %w[check_nrpe check_disk check_file_age].each do |nplugin|
              it do
                should contain_intermapper__nagios_plugin_link(
                  nplugin
                ).with_ensure('absent')
              end
            end
          end
        end
        # describe when_true
      end
      # describe nagios_manage

      describe 'nagios_link_plugins' do
        describe 'should allow overrides' do
          pnames = %w[foo bar baz]
          let :params do
            {
              nagios_manage: true,
              nagios_plugins_dir: '/usr/lib64/nagios-plugins',
              nagios_link_plugins: pnames
            }
          end
          pnames.each do |p|
            it do should contain_intermapper__nagios_plugin_link(p) end
          end
        end
      end
      # describe nagios_link_plugins
    end
    # describe intermapper::nagios
  end

  shared_context 'RedHat' do
    describe 'intermapper::service' do
      it do
        should contain_service('intermapperd').with(
          provider: nil,
          status: nil
        )
      end
    end
  end

  # See metadata.json
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end
      case facts[:os]['family']
      when 'RedHat' then
        include_context 'Supported Platform'
        it_behaves_like 'RedHat'
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength