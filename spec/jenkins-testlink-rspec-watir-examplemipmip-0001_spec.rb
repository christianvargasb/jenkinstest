require 'rspec'
require 'watir'
require 'rbconfig'
require 'yaml'

@os ||= (
	host_os = RbConfig::CONFIG['host_os']
	case host_os
	when /mswin|msys|mingw|cygwin|bccwin|wince|emc/
		:windows
	when /darwin|mac os/
		:macosx
	when /linux/
		require 'headless'
		$headless = Headless.new
		$headless.start
	when /solaris|bsd/
		:unix
	else
		raise Error::WebDriverError, "unknown os: #{host_os.inspect}"
	end
)

if browsertype = ENV["browser"]
	case browsertype
	when /ie/
		$browser = Watir::Browser.new
	when /safari/
		require "watir-webdriver"  # For web automation.
		$browser = Watir::Browser.new
	when /firefox/

		require "watir-webdriver"  # For web automation.
		$browser = Watir::Browser.new

	when /chrome/
		require "watir-webdriver"  # For web automation.
		$browser = Watir::Browser.new :chrome

	else
		raise Error::WebDriverError, "unknown browser: #{browsertype.inspect}"
	end
else
	$browser = Watir::Browser.new
end


RSpec.configure do |config|

	config.after(:suite) { 

		$browser.close unless $browser.nil? 
		$headless.destroy unless $headless.nil?
	}

	config.before(:each) {
		@browser = $browser
		@browser.goto($baseurl)  
	}
end

$baseurl = 'http://mipmip.github.io/jenkins-testlink-rspec-watir-example'
$waitfortext = 'We will automatically test this page with Watir.'

describe "jenkins-testlink-rspec-watir-example" do
  describe "mipmip-0001" do
    
      context "The website should load without problems | req-0001" do
        
        it "should not show 404 text | TC0001" do
			expect(@browser.text).not_to include('404')
        end
        
        it "should show a text | tc-0001-02" do
			p $baseurl
			expect(@browser.text).to include('Jenkins-testlink-rspec-watir-example')
        end
      end
    
      context "The title should be displayed somewhere in the text | req-0002" do
        
        it "should show a text | tc-0002-01" do
			expect(@browser.text).to include('Jenkins-testlink-rspec-watir-example')
		end
        
      end
    
  end
end
