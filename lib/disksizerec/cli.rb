# coding: utf-8

require 'thor'

module Disksizerec
  class CLI < Thor
    
    desc "hello NAME", "say hello to NAME"
    def hello(name)
      puts "Hello #{name}"
    end

  end
end
