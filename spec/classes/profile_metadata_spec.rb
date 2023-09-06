require 'spec_helper'

describe 'profile_metadata' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      if os_facts[:os]['family'] == 'windows'
        let(:facts) do
          os_facts.merge(
            puppet_agent_appdata: 'C:\\ProgramData',
          )
        end
      else
        let(:facts) { os_facts }
      end

      it { is_expected.to compile }

      case os_facts[:osfamily]
      when 'Darwin'
        it { is_expected.to contain_concat('/opt/puppetlabs/facter/facts.d/profile_metadata.yaml').with_owner('root').with_group('wheel') }
      when 'windows'
        it { is_expected.to contain_concat('C:/ProgramData/PuppetLabs/facter/facts.d/profile_metadata.yaml').with_owner('Administrator').with_group('Administrators') }
      else
        it { is_expected.to contain_concat('/opt/puppetlabs/facter/facts.d/profile_metadata.yaml').with_owner('root').with_group('root') }
      end
    end
  end
end
