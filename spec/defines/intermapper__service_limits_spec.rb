require 'spec_helper' # frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
describe 'intermapper::service_limits', type: :define do
  let :pre_condition do
    'class { intermapper: intermapper_service_limits => {}, }'
  end

  shared_context 'Supported Platform' do
    describe 'title is foo' do
      let :title do
        'foo'
      end
      it do should_not compile end
      it do
        is_expected.to raise_error(Puppet::Error, /Error.+got 'foo'/)
      end
    end

    %w[intermapperd imdc imflows].each do |title|
      describe "title is #{title}" do
        let :title do
          title
        end
        it do should compile end
        it do
          should contain_file(
            "/etc/systemd/system/#{title}.service.d"
          ).with(
            ensure: 'directory'
          )
        end

        it do
          should contain_file(
            "/etc/systemd/system/#{title}.service.d/limits.conf"
          ).with(
            ensure: 'file',
            owner: 'root',
            group: 'root',
            content: /\[Service\]$/
          )
        end

        it do
          should contain_exec(
            "#{title} systemctl daemon-reload"
          ).with(
            command: 'systemctl daemon-reload',
            path: ['/sbin', '/bin', '/usr/sbin', '/usr/bin'],
            refreshonly: true
          ).that_subscribes_to(
            "File[/etc/systemd/system/#{title}.service.d]"
          ).that_subscribes_to(
            "File[/etc/systemd/system/#{title}.service.d/limits.conf]"
          )
        end

        case title
        when 'intermapperd' then
          it do
            should contain_file(
              "/etc/systemd/system/#{title}.service.d"
            ).that_notifies('Class[intermapper::service]')
          end
          it do
            should contain_file(
              "/etc/systemd/system/#{title}.service.d/limits.conf"
            ).that_notifies('Class[intermapper::service]')
          end
        else
          it do
            should contain_file(
              "/etc/systemd/system/#{title}.service.d"
            ).that_notifies('Class[intermapper::service_extra]')
          end
          it do
            should contain_file(
              "/etc/systemd/system/#{title}.service.d/limits.conf"
            ).that_notifies('Class[intermapper::service_extra]')
          end
        end

        context 'with params set' do
          let :params do
            {
              limitcpu: 'infinity',
              limitfsize: 'infinity',
              limitdata: 'infinity',
              limitstack: 8192,
              limitcore: 0,
              limitrss: 'infinity',
              limitnofile: 65_536,
              limitas: 'infinity',
              limitnproc: 655_360,
              limitmemlock: 64,
              limitlocks: 'infinity',
              limitsigpending: 7_260,
              limitmsgqueue: 819_200,
              limitnice: 0,
              limitrtprio: 0,
              limitrttime: 'infinity'
            }
          end
          it do
            should contain_file(
              "/etc/systemd/system/#{title}.service.d/limits.conf"
            ).with_content(
              /\n LimitCPU=infinity$/
            ).with_content(
              /\n LimitFSIZE=infinity$/
            ).with_content(
              /\n LimitDATA=infinity$/
            ).with_content(
              /\n LimitSTACK=8192$/
            ).with_content(
              /\n LimitCORE=0$/
            ).with_content(
              /\n LimitRSS=infinity$/
            ).with_content(
              /\n LimitNOFILE=65536$/
            ).with_content(
              /\n LimitAS=infinity$/
            ).with_content(
              /\n LimitNPROC=655360$/
            ).with_content(
              /\n LimitMEMLOCK=64$/
            ).with_content(
              /\n LimitLOCKS=infinity$/
            ).with_content(
              /\n LimitSIGPENDING=7260$/
            ).with_content(
              /\n LimitMSGQUEUE=819200$/
            ).with_content(
              /\n LimitNICE=0$/
            ).with_content(
              /\n LimitRTPRIO=0$/
            ).with_content(
              /\n LimitRTTIME=infinity$/
            )
          end
        end
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
      when 'Debian', 'RedHat' then
        include_context 'Supported Platform'
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
