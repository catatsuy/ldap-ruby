require 'net/ldap'
require 'sinatra'
require 'sinatra/json'
require 'yaml'

Settings = YAML::load(IO::read('settings.yml'))

ldap = Net::LDAP.new(
  host: Settings['host'],
  port: Settings['port'],
  auth: {
    method: :simple,
    username: Settings['bind_dn'],
    password: Settings['password']
  }
)

treebase = Settings['base']
filter = Net::LDAP::Filter.eq('uid', '*')
users = []
ldap.search(base: treebase, filter: filter, return_result: false) do |entry|
  users.push entry.uid[0]
end

get '/' do
  json users
end
