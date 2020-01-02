require 'spec_helper'

describe 'profile_metadata::service' do
  let(:title) { 'profile::my_profile' }
  let(:params) do
    {
      'owner_uid' => 'john.doe',
      'team' => 'infracore',
      'end_users' => [
        'group1@example.com',
        'group2@example.com',
      ],
      'escalation_period' => 'pdx-workhours',
      'downtime_impact' => 'Development work will be blocked because their changes cannot be tested and thus cannot be merged.',
      'notes' => 'This is just a test :)',
      'doc_urls' => ['https://www.example.com/page1'],
      'human_name' => 'Internal InfraCore CI',
      'other_fqdns' => ['alt.example.com'],
    }
  end

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
