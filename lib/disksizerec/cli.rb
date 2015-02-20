# coding: utf-8

require 'thor'
require 'ohai'


module Disksizerec
  class CLI < Thor

    class_option :silent, type: :boolean, default: false, desc: 'Not display data', aliases: '-s'

    default_command :check


    desc "check", "Check the sizes of mounted disks and store them to a host or just display them"
    option :store, type: :string, desc: 'MongoDB server info to store data (host[:port])', default: ''
    option :db, type: :string, desc: 'DB name to store data', default: ''
    def check
      store = options[:store]
      db = options[:db]
      puts "check with #{store}"
      sizes = get_disk_sizes
      puts sizes.inspect
      
      return  if store == ''
      abort 'Error: DB name should be specified with --db option'  if db == ''
      
      store_sizes sizes, store, db
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
    
    
    # Store size data
    def store_sizes(sizes, store, db)
      puts "store_sizes to #{store}, #{db}"
      
    end

  end
end
