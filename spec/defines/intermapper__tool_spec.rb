require 'spec_helper'

describe 'intermapper::tool', :type => :define do
  t='edu.ucsd.testtool'
  td='/var/local/InterMapper_Settings/Tools' # assume it hasn't been overriden
  fname="#{td}/#{t}"
  let(:title) { t }

  ['CentOS', 'RedHat', 'Solaris'].each do |system|
    context "when on system #{system}" do
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
        it { should contain_file(fname)\
             .that_notifies('Class[intermapper::service]')\
             .that_requires('Class[intermapper::install]')\
             .with_force(nil)\
             .with_content(nil)\
             .with_source(nil)\
             .with_target(nil)\
             .with_owner('intermapper')\
             .with_group('intermapper')
        }
      end

      describe 'force' do
        [true, false].each do |tf|
          describe "is #{tf}" do
            let(:params) {{
              :force => tf,
            }}
            it { should contain_file(fname).with_force(tf) }
          end
        end
      end

      describe 'content is set' do
        c = 'This is probe content'
        let(:params) {{
          :content => c,
        }}
        it { should contain_file(fname).with_content(c) }
      end

      describe 'source is set' do
        s = '/tmp/testfile'
        let(:params) {{
          :source => s,
        }}
        it { should contain_file(fname).with_source(s) }
      end

      describe 'mode is set' do
        m = '0755'
        let(:params) {{
          :mode => m,
        }}
        it { should contain_file(fname).with_mode(m) }
      end

      describe 'linking' do
        tgt = '/tmp/sourcefile'

        describe 'with ensure == link and target set' do
          let(:params) {{
            :ensure => 'link',
            :target => tgt,
          }}
          it { should contain_file(fname).with({
            :ensure => 'link',
            :target => tgt,
          }) }
        end

        describe 'with ensure set to link target' do
          let(:params) {{
            :ensure => tgt,
          }}
          it { should contain_file(fname).with_ensure(tgt) }
        end

      end

    end # on system
  end # each system
end
