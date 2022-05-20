files = Dir[File.join(".", "/lib/fiskaly_ruby/**/*.rb")]
sorted_files = files.select { |f| f.include? '/base' } + files.reject { |f| f.include? '/base' }
sorted_files.delete './lib/fiskaly_ruby/base_request.rb'
sorted_files.prepend './lib/fiskaly_ruby/base_request.rb'
sorted_files.each { |f| require_relative f[6..] }
puts sorted_files

module FiskalyRuby
  VERSION = '0.1.0'

  COMMANDS = [
    FiskalyRuby::Management::Authenticate,
    FiskalyRuby::Management::Organizations::Create,
    FiskalyRuby::Management::Organizations::Retrieve,
    FiskalyRuby::Management::Organizations::ApiKeys::Create,
    FiskalyRuby::Management::Organizations::ApiKeys::List,
    FiskalyRuby::KassenSichV::Authenticate,
    FiskalyRuby::KassenSichV::Admin::Authenticate,
    FiskalyRuby::KassenSichV::Admin::Logout,
    FiskalyRuby::KassenSichV::TSS::Client::Create,
    FiskalyRuby::KassenSichV::TSS::Client::Retrieve,
    FiskalyRuby::KassenSichV::TSS::Export::Retrieve,
    FiskalyRuby::KassenSichV::TSS::Export::RetrieveFile,
    FiskalyRuby::KassenSichV::TSS::Export::Trigger,
    FiskalyRuby::KassenSichV::TSS::Tx::Upsert
  ]

  class << self
    COMMANDS.each do |command|
      name = command.name
      method_name = name.split('::')[1..].map do |command_name|
         case command_name
         when 'KassenSichV' then command_name.downcase
         when 'TSS' then command_name.downcase
         else command_name.gsub(/(.)([A-Z])/, '\1_\2').downcase
         end
      end.join('_')

      define_method(method_name) do |args|
         command.call(args)
      end
    end
  end
end
