require 'spec_helper' # frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
describe 'intermapper', type: :class do
  shared_context 'Supported Platform' do
    it do should compile end
    it do should contain_class('intermapper::install') end
    it do should contain_class('intermapper::config') end
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

      describe 'nagios_plugins_package_name is an Array' do
        npkgs = ['nagios-plugins', 'nagios-plugins-all']

        describe 'nagios_manage is false' do
          let :params do
            { nagios_manage: false, nagios_plugins_package_name: npkgs }
          end
          it do should_not contain_package('nagios-plugins') end
          it do should_not contain_package('nagios-plugins-all') end
        end

        describe 'nagios_manage is true' do
          let :params do
            { nagios_manage: true, nagios_plugins_package_name: npkgs }
          end
          it do should contain_package('nagios-plugins') end
          it do should contain_package('nagios-plugins-all') end
        end
      end
    end
    # describe intermapper::install

    describe 'intermapper::config' do
      let :params do
        {
          package_ensure: 'present',
          package_name: 'intermapper',
          package_manage: true
        }
      end
      it do should contain_class('intermapper::nagios') end
      it do
        should contain_file('intermapperd.conf').with(
          ensure: 'file',
          owner: 'root',
          group: 'root',
          mode: '0644'
        )
      end

      describe 'should allow intermapper::icon types to be created' do
        let :params do
          {
            intermapper_icons: { 'foo.png': { source: '/tmp/foo.png' } }
          }
        end
        it do
          should contain_intermapper__icon('foo.png').with_source(
            '/tmp/foo.png'
          )
        end
      end
    end
    # describe intermapper::config

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
        it do
          should contain_intermapper__service_limits('intermapperd').with(
            ensure: 'present',
            limitnproc: '327680:655360',
            limitnofile: '32768:65536',
          )
        end
        it do
          should contain_intermapper__service_limits('imdc').with(
            ensure: 'present',
            limitnproc: '327680:655360',
            limitnofile: '32768:65536',
          )
        end
        it do
          should contain_intermapper__service_limits('imflows').with(
            ensure: 'present',
            limitnproc: '327680:655360',
            limitnofile: '32768:65536',
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
          should_not contain_intermapper__tool('check_nrpe')
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
            it do should_not compile end
            it do should raise_error(Puppet::Error, /Absolute/) end
          end

          describe 'with nagios_ensure == present and plugins dir set' do
            let :params do
              {
                nagios_ensure: 'present',
                nagios_manage: true,
                nagios_plugins_dir: '/usr/lib64/nagios-plugins'
              }
            end
            # This is a subset of the defaults in data/common.yaml
            %w[check_nrpe check_disk check_file_age].each do |nplugin|
              it do
                should contain_intermapper__tool(nplugin).with(
                  ensure: 'link',
                  target: "/usr/lib64/nagios-plugins/#{nplugin}"
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
                should contain_intermapper__tool(nplugin).with_ensure('absent')
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
            it do should contain_intermapper__tool(p) end
          end
        end
      end
      # describe nagios_link_plugins
    end
    # describe intermapper::nagios

    describe 'intermapper::service' do
      it do
        should contain_service('intermapperd').with(
          provider: nil,
          status: nil
        )
      end
    end
  end

  shared_context 'Debian' do
    it do should contain_package('fonts-hack-ttf') end
  end

  shared_context 'RedHat' do
    it do should contain_package('dejavu-sans-fonts') end
  end

  # See metadata.json
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end
      include_context 'Supported Platform'

      case facts[:os]['family']
      when 'Debian' then it_behaves_like 'Debian'
      when 'RedHat' then it_behaves_like 'RedHat'
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
