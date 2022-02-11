# frozen_string_literal: true

# Override by OS
case os.family
when 'debian', 'redhat'
  file_name = '/etc/suricata/suricata.yaml'
  user = 'suricata'
  group = 'root'
  mode = '0640'
end

control 'suricata configuration' do
  title 'should match desired lines'

  describe file(file_name) do
    it { should be_file }
    it { should be_owned_by user }
    it { should be_grouped_into group }
    its('mode') { should cmp mode }
  end
end
