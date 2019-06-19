require 'spec_helper' # frozen_string_literal: true

describe 'intermapper::service_limits', type: :define do
  let :pre_condition do
    'class { intermapper: intermapper_service_limits => {}, }'
  end

  shared_context 'Supported Platform' do
    describe 'title is foo' do
      let :title do
        'foo'
      end

      it do is_expected.not_to compile end
      it do
        is_expected.to raise_error(Puppet::Error, %r{Error.+got 'foo'})
      end
    end

    ['intermapperd', 'imdc', 'imflows'].each do |title|
      describe "title is #{title}" do
        let :title do
          title
        end

        it do is_expected.to compile end
        it do
          is_expected.to contain_file("/etc/systemd/system/#{title}.service.d").with_ensure('directory')
        end

        it do
          is_expected.to contain_file("/etc/systemd/system/#{title}.service.d/limits.conf").with(
            ensure: 'file',
            owner: 'root',
            group: 'root',
            content: %r{\[Service\]$},
          )
        end

        it do
          is_expected.to contain_exec("#{title} systemctl daemon-reload").with(
            command: 'systemctl daemon-reload',
            path: ['/sbin', '/bin', '/usr/sbin', '/usr/bin'],
            refreshonly: true,
          ).that_subscribes_to(
            "File[/etc/systemd/system/#{title}.service.d]",
          ).that_subscribes_to(
            "File[/etc/systemd/system/#{title}.service.d/limits.conf]",
          )
        end

        case title
        when 'intermapperd' then
          it do
            is_expected.to contain_file("/etc/systemd/system/#{title}.service.d").that_notifies('Class[intermapper::service]')
          end
          it do
            is_expected.to contain_file("/etc/systemd/system/#{title}.service.d/limits.conf").that_notifies('Class[intermapper::service]')
          end
        else
          it do
            is_expected.to contain_file("/etc/systemd/system/#{title}.service.d").that_notifies('Class[intermapper::service_extra]')
          end
          it do
            is_expected.to contain_file("/etc/systemd/system/#{title}.service.d/limits.conf").that_notifies('Class[intermapper::service_extra]')
          end
        end

        context 'with params set' do
          let :params do
            {
              limitcpu: 'infinity',
              limitfsize: 'infinity',
              limitdata: 'infinity',
              limitstack: '8388608:infinity',
              limitcore: '0:infinity',
              limitrss: 'infinity',
              limitnofile: 65_536,
              limitas: 'infinity',
              limitnproc: 655_360,
              limitmemlock: 65_536,
              limitlocks: 'infinity',
              limitsigpending: 31_192,
              limitmsgqueue: 819_200,
              limitnice: 0,
              limitrtprio: 0,
              limitrttime: 'infinity',
            }
          end

          it do
            is_expected.to contain_file("/etc/systemd/system/#{title}.service.d/limits.conf").with_content(
              %r{\n LimitCPU=infinity$},
            ).with_content(
              %r{\n LimitFSIZE=infinity$},
            ).with_content(
              %r{\n LimitDATA=infinity$},
            ).with_content(
              %r{\n LimitSTACK=8388608:infinity$},
            ).with_content(
              %r{\n LimitCORE=0:infinity$},
            ).with_content(
              %r{\n LimitRSS=infinity$},
            ).with_content(
              %r{\n LimitNOFILE=65536$},
            ).with_content(
              %r{\n LimitAS=infinity$},
            ).with_content(
              %r{\n LimitNPROC=655360$},
            ).with_content(
              %r{\n LimitMEMLOCK=65536$},
            ).with_content(
              %r{\n LimitLOCKS=infinity$},
            ).with_content(
              %r{\n LimitSIGPENDING=31192$},
            ).with_content(
              %r{\n LimitMSGQUEUE=819200$},
            ).with_content(
              %r{\n LimitNICE=0$},
            ).with_content(
              %r{\n LimitRTPRIO=0$},
            ).with_content(
              %r{\n LimitRTTIME=infinity$},
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

      include_context 'Supported Platform'
    end
  end
end
