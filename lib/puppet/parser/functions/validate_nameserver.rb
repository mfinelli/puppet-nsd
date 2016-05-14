# == Function: validate_nameserver
#
# Validates an array of nameservers ensuring that they end in a full stop.
#
# === Examples
#
# The following values will pass:
#
# validate_nameserver(['ns1.example.com.'])
# validate_nameserver(['ns1.example.com'])
#
# The following values will raise an error:
#
# validate_nameserver('ns1.example.com')
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
  newfunction(:validate_nameserver, :doc => <<-ENDHEREDOC
    Validates an array of nameservers, ensuring that it is an array.
    The following values will pass:

    validate_nameserver(['ns1.example.com.'])
    validate_nameserver(['ns1.example.com'])

    The following values will raise an error:

    validate_nameserver('ns1.example.com')

  ENDHEREDOC
  ) do |args|

    # Make sure that we've got something to validate!
    unless args.length == 1
      error_msg = 'validate_nameserver: wrong number of arguments ' +
          "(#{args.length}; must be = 1)"
      raise Puppet::ParseError, (error_msg)
    end

    # Make sure that we were given an array.
    unless args[0].is_a?(Array)
      error_msg = "#{args[0].inspect} is not an Array.  It looks to be a " +
          "#{args[0].class}"
      raise Puppet::ParseError, (error_msg)
    end

  end
end
