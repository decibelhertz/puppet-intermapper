require 'spec_helper'

describe 'intermapper::probe', :type => :define do
  t='edu.ucsd.testprobe'
  td='/var/local/InterMapper_Settings/Probes' # assume it hasn't been overriden
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
             .that_requires('Class[intermapper::install]')
        }
      end

    end # on system
  end # each system
end
