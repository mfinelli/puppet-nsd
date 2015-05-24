require 'beaker-rspec'

hosts.each do |host|
  # Install Puppet
  on host, install_puppet
end

RSpec.configure do |c|
  module_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    # Install module
    puppet_module_install(:source => module_root, :module_name => 'nsd')
    hosts.each do |host|
      # Install module dependencies.
      on host, puppet('module', 'install',
                      'puppetlabs-stdlib', '--version 4.6.0'),
         {:acceptable_exit_codes => [0, 1]}
      on host, puppet('module', 'install',
                      'puppetlabs-concat', '--version 1.2.1'),
         {:acceptable_exit_codes => [0, 1]}

      # Copy over the files we need.
      %w(control.cert control.key server.cert server.key).each do |file|
        scp_to(host, module_root + '/spec/fixtures/files/' + file, '/root/' + file)
      end
    end
  end
end
