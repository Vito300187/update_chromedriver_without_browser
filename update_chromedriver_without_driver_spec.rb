require 'net/http'
require 'open-uri'
require 'nokogiri'

zip_file_name = { 'mac' => 'chromedriver_mac64.zip', 'linux' => 'chromedriver_linux64.zip' }
latest_version = Net::HTTP.get(URI('https://chromedriver.storage.googleapis.com/LATEST_RELEASE'))
chromedriver_storage = 'https://chromedriver.storage.googleapis.com/'
new_chromedriver_name = './chromedriver.zip'
current_version = `chromedriver -v`.strip.split(' ').delete_if { |a| a.length > 20 }.last
path_old_driver = `which chromedriver`.chomp
link = "#{chromedriver_storage}#{latest_version}/#{zip_file_name['mac']}"

def unzip_chromedriver(new_file, old_file)
  File.delete(old_file) if File.exist?(old_file)
  `unzip #{new_file} -d #{File.dirname(old_file)}`
end

def compare_current_driver_and(current_version, latest_version)
  abort('Update not required') if current_version.eql?(latest_version)
end

def replace_chromedriver(new_chromedriver, link, path_old_driver)
  File.new(new_chromedriver, 'w') << URI.parse(link).read
  unzip_chromedriver(new_chromedriver, path_old_driver)
  File.delete(new_chromedriver)
end

compare_current_driver_and(current_version, latest_version)
replace_chromedriver(new_chromedriver_name, link, path_old_driver)
