# == Function: validate_ip_address_array
#
# Validates an array of IP addresses, raising a ParseError should one or more
# addresses fail. Validates both v4 and v6 IP addresses.
#
# === Examples
#
# The following values will pass:
#
# validate_ip_address_array(['127.0.0.1', '::1'])
#
# The following values will raise an error:
#
# validate_ip_address_array('127.0.0.1')
# validate_ip_address_array(['not-an-address'])
#
# === Authors
#
# Mario Finelli <mario@finel.li>
#
# === Copyright
#
# Copyright 2015 Mario Finelli
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
module Puppet::Parser::Functions
  newfunction(:validate_ip_address_array, :doc => <<-ENDHEREDOC
    Validates an array of IP addresses, raising a ParseError should one or
    more addresses fail. Validates both v4 and v6 IP addresses.

    The following values will pass:

    validate_ip_address_array(['127.0.0.1', '::1'])

    The following values will raise an error:

    validate_ip_address_array('127.0.0.1')
    validate_ip_address_array(['not-an-address'])

  ENDHEREDOC

  ) do |args|

    require 'ipaddr'

    # Make sure that we've got something to validate!
    unless args.length > 0
      error_msg = 'validate_ip_address_array: wrong number of arguments ' +
          "(#{args.length}; must be > 0)"
      raise Puppet::ParseError, (error_msg)
    end

    args.each do |arg|
      # Raise an error if we don't have an array.
      unless arg.is_a?(Array)
        error_msg = "#{arg.inspect} is not an Array.  It looks to be a " +
            "#{arg.class}"
        raise Puppet::ParseError, (error_msg)
      end

      arg.each do |addr|
        # Make sure that we were given a string.
        unless addr.is_a?(String)
          raise Puppet::ParseError, "#{addr.inspect} is not a string."
        end

        error_msg = "#{addr.inspect} is not a valid IP address."

        # Raise an error if we don't get a valid IP address (v4 or v6).
        begin
          ip = IPAddr.new(addr)
          raise Puppet::ParseError, error_msg unless ip.ipv4? or ip.ipv6?
        rescue ArgumentError
          raise Puppet::ParseError, error_msg
        end
      end

    end
  end
end
