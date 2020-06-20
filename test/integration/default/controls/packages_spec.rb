# Overide by OS
package_name = 'suricata'

control 'suricata package' do
  title 'should be installed'

  describe package(package_name) do
    it { should be_installed }
  end
end
