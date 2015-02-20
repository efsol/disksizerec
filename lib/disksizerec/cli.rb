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
      # puts "exec with #{store}"
      sizes = get_disk_sizes
      puts sizes.inspect
      
      return  if store == ''
      abort 'Error: DB name should be specified with --db option'  if db == ''
      
      store_sizes store, port, db, sizes
    end
    
    
    
    private
    
    # Get the sizes of mounted disks
    def get_disk_sizes
      oh = Ohai::System.new
      oh.all_plugins

      sizes = []
      oh[:filesystem].each do |key, value|
        next  unless value.key?(:kb_used)

        size = {
            mount: value[:mount],
            mb_used: value[:kb_used].to_i / 1024, 
            mb_available: value[:kb_available].to_i / 1024,
            created_at: Time.now
        }
        sizes << size
      end
      sizes
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
