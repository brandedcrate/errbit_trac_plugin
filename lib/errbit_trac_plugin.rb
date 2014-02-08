require "errbit_trac_plugin/version"
require 'errbit_trac_plugin/error'
require 'errbit_trac_plugin/issue_tracker'
require 'errbit_trac_plugin/rails'

module ErrbitTracPlugin
  def self.root
    File.expand_path '../..', __FILE__
  end

  def self.pretty_hash(hash, nesting = 0)
    tab_size = 2
    nesting += 1

    pretty  = "{"
    sorted_keys = hash.keys.sort
    sorted_keys.each do |key|
      val = hash[key].is_a?(Hash) ? pretty_hash(hash[key], nesting) : hash[key].inspect
      pretty += "\n#{' '*nesting*tab_size}"
      pretty += "#{key.inspect} => #{val}"
      pretty += "," unless key == sorted_keys.last

    end
    nesting -= 1
    pretty += "\n#{' '*nesting*tab_size}}"
  end
end

ErrbitPlugin::Register.add_issue_tracker(
  'ErrbitTracPlugin::IssueTracker',
  ErrbitTracPlugin::IssueTracker
)
