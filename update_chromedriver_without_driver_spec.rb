# frozen_string_literal: true

require 'yaml'
require 'net/http'
require 'open-uri'

def unzip_chromedriver(new_file, old_file)
  File.delete(old_file) if File.exist?(old_file)
  `unzip #{new_file} -d #{File.dirname(old_file)}`
end

def compare_current_driver_and(latest_version, current_version = nil)
  if current_version.nil?
    puts MESSAGE['logging']['install_driver']
  elsif current_version.eql?(latest_version)
    abort(MESSAGE['logging']['update_is_not_required'])
  end
end

def replace_chromedriver(new_chromedriver, link, path_old_driver)
  File.new(new_chromedriver, 'w') << URI.parse(link).read
  unzip_chromedriver(new_chromedriver, path_old_driver)
  File.delete(new_chromedriver)
end

MESSAGE = YAML.safe_load(File.read('./message.yaml'))
chrome_version = YAML.safe_load(File.read('./chrome_driver_v.yaml'))
os = ENV['OS'].nil? ? (raise MESSAGE['error']['not_os']) : ENV['OS'].downcase.strip

zip_file_name = chrome_version[os]
latest_version = Net::HTTP.get(URI('https://chromedriver.storage.googleapis.com/LATEST_RELEASE'))

begin
  current_version = `chromedriver -v`.strip.split(' ').delete_if { |a| a.length > 20 }.last
rescue StandardError => e
  puts "#{e}, #{MESSAGE['error']['driver_not_found']}"
end

chromedriver_storage = 'https://chromedriver.storage.googleapis.com/'
new_chromedriver_name = './chromedriver.zip'

path_old_driver = `which chromedriver`.empty? ? '/usr/local/bin/chromedriver' : `which chromedriver`.chomp
link = "#{chromedriver_storage}#{latest_version}/#{zip_file_name}"

compare_current_driver_and(latest_version, current_version)
replace_chromedriver(new_chromedriver_name, link, path_old_driver)
puts MESSAGE['logging']['success_update']
