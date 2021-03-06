# coding: utf-8

require 'thor'
require 'ohai'
require 'mongo'
include Mongo


module Disksizerec
  class CLI < Thor

    class_option :silent, type: :boolean, default: false, desc: 'Not display data', aliases: '-s'


    desc "exec", "Check the sizes of mounted disks and store them to a host or just display them"
    option :store, type: :string, desc: 'MongoDB host name', default: ''
    option :port, type: :numeric, desc: 'MongoDB port', default: 27017
    option :db, type: :string, desc: 'DB name to store data', default: ''
    def exec
      store = options[:store]
      port = options[:port]
      db = options[:db]
      
      
      sizes = get_sizes
      display_sizes sizes  unless options[:silent]
      
      return  if store == ''
      abort 'Error: DB name should be specified with --db option'  if db == ''
      
      store_sizes store, port, db, sizes
    end
    
    
    
    private
    
    # Ohai factory
    def ohai_factory
      if @ohai.nil?
        @ohai = Ohai::System.new
        @ohai.all_plugins
      end
      @ohai
    end
    
    
    # Get the sizes of mounted disks
    def get_sizes
      ohai_factory

      host = get_localhost_fqdn
      
      sizes = []
      @ohai[:filesystem].each do |key, value|
        next  unless value.key?(:kb_used)

        size = {
            host: host,
            mount: value[:mount],
            mb_used: value[:kb_used].to_i / 1024, 
            mb_available: value[:kb_available].to_i / 1024,
            created_at: Time.now,
        }
        sizes << size
      end
      sizes
    end
    
    
    # Get the local host FQDN
    def get_localhost_fqdn
      @ohai[:machinename]
    end
    
    
    # Display data
    def display_sizes(sizes)
      sizes.each do |size|
        puts size.to_s
      end
    end
    
    
    # Store size data
    def store_sizes(store, port, db, sizes)
      # puts "store_sizes to #{store}, #{db}"
      client = MongoClient.new store, port
      db = client.db db
      coll = db.collection 'disk_sizes'
      coll.insert sizes
    end
    
  end
end
