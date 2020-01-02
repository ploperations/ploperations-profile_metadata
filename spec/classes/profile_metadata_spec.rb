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
    end
  end
end
