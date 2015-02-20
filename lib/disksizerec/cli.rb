# coding: utf-8

require 'thor'
require 'ohai'


module Disksizerec
  class CLI < Thor

    class_option :silent, type: :boolean, default: false, desc: 'Not display data', aliases: '-s'

    default_command :check


    desc "check", "Check the sizes of mounted disks and store them to a host or just display them"
    option :store, type: :string, desc: 'MongoDB server info to store data (host[:port])'
    def check
      puts "check with #{options[:store]}"
      sizes = get_disk_sizes
      puts sizes.inspect
    end
    
    
    
    private
    
    # Get the sizes of mounted disks
    def get_disk_sizes
      oh = Ohai::System.new
      oh.all_plugins
      sizes = {}
      oh[:filesystem].each do |key, value|
        #puts "#{value[:mount]}, #{value[:kb_used]}, #{value[:kb_available]}"  if value.key?(:kb_used)
        next  unless value.key?(:kb_used)

        mount = value[:mount]
        size = { 
            mb_used: value[:kb_used].to_i / 1024, 
            mb_available: value[:kb_available].to_i / 1024
        }
        
        sizes[mount] = size
      end

      sizes
    end
    
  end
end
