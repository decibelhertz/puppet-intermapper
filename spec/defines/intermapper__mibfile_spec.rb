require 'spec_helper' # frozen_string_literal: true

describe 'intermapper::mibfile', type: :define do
  let :title do
    'edu.ucsd.testmibfile'
  end

  shared_context 'Supported Platform' do
    it do is_expected.to compile end
    it do is_expected.to contain_class('intermapper') end
    it do
      is_expected.to contain_file('/var/local/InterMapper_Settings/MIB Files/edu.ucsd.testmibfile').with(
        ensure: 'file',
        backup: nil,
        checksum: nil,
        checksum_value: nil,
        content: nil,
        force: nil,
        group: 'intermapper',
        ignore: nil,
        links: nil,
        mode: '0644',
        owner: 'intermapper',
        path: '/var/local/InterMapper_Settings/MIB Files/edu.ucsd.testmibfile',
        provider: nil,
        purge: nil,
        recurse: nil,
        recurselimit: nil,
        replace: nil,
        selinux_ignore_defaults: nil,
        selrange: nil,
        selrole: nil,
        seltype: nil,
        seluser: nil,
        show_diff: nil,
        source: nil,
        source_permissions: nil,
        sourceselect: nil,
        target: nil,
        validate_cmd: nil,
        validate_replacement: nil,
      ).that_requires('Class[intermapper::install]').that_notifies('Class[intermapper::service]')
    end

    # Turn on/off a bunch of boolean params
    ['force', 'purge', 'recurse', 'replace', 'selinux_ignore_defaults', 'show_diff'].each do |p|
      [true, false].each do |b|
        describe "file param '#{p}' is set to '#{b}'" do
          let :params do
            { p => b }
          end

          it do
            is_expected.to contain_file('/var/local/InterMapper_Settings/MIB Files/edu.ucsd.testmibfile').with(
              p => b,
            )
          end
        end
      end
    end

    describe 'ensure is set to directory' do
      let :params do
        { ensure: 'directory' }
      end

      it do
        is_expected.to raise_error(
          Puppet::Error,
          %r{Error while evaluating a Resource Statement, Intermapper::Mibfile},
        )
      end
    end

    describe 'content is set' do
      c = 'This is probe content'
      let :params do
        { content: c }
      end

      it do
        is_expected.to contain_file('/var/local/InterMapper_Settings/MIB Files/edu.ucsd.testmibfile').with_content(c)
      end
    end

    describe 'source is set' do
      s = '/tmp/testfile'
      let :params do
        { source: s }
      end

      it do
        is_expected.to contain_file('/var/local/InterMapper_Settings/MIB Files/edu.ucsd.testmibfile').with_source(s)
      end
    end

    describe 'mode is set' do
      m = '0755'
      let :params do
        { mode: m }
      end

      it do
        is_expected.to contain_file('/var/local/InterMapper_Settings/MIB Files/edu.ucsd.testmibfile').with_mode(m)
      end
    end

    describe 'linking' do
      tgt = '/tmp/sourcefile'

      describe 'with ensure == link and target set' do
        let :params do
          { ensure: 'link', target: tgt }
        end

        it do
          is_expected.to contain_file('/var/local/InterMapper_Settings/MIB Files/edu.ucsd.testmibfile').with(
            ensure: 'link',
            target: tgt,
          )
        end
      end

      # This type of shortcut is deprecated as of 4.3.0, so we make it fail
      describe 'with ensure set to link target' do
        let :params do
          { ensure: tgt }
        end

        it do is_expected.not_to compile end
      end
    end
  end
  # Supported Platform

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
