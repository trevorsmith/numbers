require 'helper'

class TestNumbers < Test::Unit::TestCase
  should "probably rename this file and start testing for real" do
    flunk "hey buddy, you should probably rename this file and start testing for real"
  end

  # require 'pp'

  # private_key = '/Volumnes/Home/Desktop/ga.p12'
  # email_address = '1036399466463@developer.gserviceaccount.com'

  # Numbers::Client.instance.token = Numbers::AuthToken.new(email_address, File.read(private_key))

  # puts "Utils.prefix(:pageviews)"
  # pp Numbers::Utils.prefix(:pageviews)
  # puts

  # puts "Utils.prefix(:avg_time_on_site)"
  # pp Numbers::Utils.prefix(:avg_time_on_site)
  # puts

  # puts "Utils.prefix([:pageviews, :avg_time_on_site])"
  # pp Numbers::Utils.prefix([:pageviews, :avg_time_on_site])
  # puts

  # puts "Utils.prefix([])"
  # pp Numbers::Utils.prefix([])
  # puts

  # puts "Utils.unprefix('ga:pageviews')"
  # pp Numbers::Utils.unprefix('ga:pageviews')
  # puts

  # puts "Utils.unprefix('ga:avgTimeOnSite')"
  # pp Numbers::Utils.unprefix('ga:avgTimeOnSite')
  # puts

  # puts "Utils.unprefix(['ga:pageviews', 'ga:avgTimeOnSite'])"
  # pp Numbers::Utils.unprefix(['ga:pageviews', 'ga:avgTimeOnSite'])
  # puts

  # puts "Utils.unprefix([])"
  # pp Numbers::Utils.unprefix([])
  # puts

  # puts "Token#to_s"
  # puts Numbers::Client.instance.token.to_s
  # puts

  # puts "Account.all"
  # pp Numbers::Account.all
  # puts

  # puts "Account.find(1973499)"
  # pp Numbers::Account.find(1973499)
  # puts

  # puts "Account.find(1234)"
  # pp Numbers::Account.find(1234)
  # puts

  # puts "WebProperty.all.size"
  # puts Numbers::WebProperty.all.size
  # puts

  # puts "WebProperty.all(:account => Numbers::Account.find(1973499)).size"
  # puts Numbers::WebProperty.all(:account => Numbers::Account.find(1973499)).size
  # puts

  # puts "WebProperty.all(:account_id => 1973499).size"
  # puts Numbers::WebProperty.all(:account_id => 1973499).size
  # puts

  # puts "WebProperty.all(:account_id => 123).size"
  # puts Numbers::WebProperty.all(:account_id => 123).size
  # puts

  # puts "WebProperty.find('UA-1973499-102')"
  # pp Numbers::WebProperty.find('UA-1973499-102')
  # puts

  # puts "WebProperty.find(123)"
  # pp Numbers::WebProperty.find(123)
  # puts

  # puts "Profile.all.size"
  # puts Numbers::Profile.all.size
  # puts

  # puts "Profile.all(:account => Numbers::Account.find(1973499)).size"
  # puts Numbers::Profile.all(:account => Numbers::Account.find(1973499)).size
  # puts

  # puts "Profile.all(:account => Numbers::Account.find(1973499), :web_property => Numbers::WebProperty.find('UA-1973499-102')).size"
  # puts Numbers::Profile.all(:account => Numbers::Account.find(1973499), :web_property => Numbers::WebProperty.find('UA-1973499-102')).size
  # puts

  # puts "Profile.all(:account_id => 1973499).size"
  # puts Numbers::Profile.all(:account_id => 1973499).size
  # puts

  # puts "Profile.all(:account_id => 1973499, :web_property_id => 'UA-1973499-102').size"
  # puts Numbers::Profile.all(:account_id => 1973499, :web_property_id => 'UA-1973499-102').size
  # puts

  # puts "Profile.all(:account_id => 123).size"
  # puts Numbers::Profile.all(:account_id => 123).size
  # puts

  # puts "Profile.find(22191089)"
  # pp Numbers::Profile.find(22191089)
  # puts

  # puts "Profile.find(123)"
  # pp Numbers::Profile.find(123)
  # puts


  # pp Numbers::Report.query(:profile_id => 49739500, :metrics => [:pageviews], :dimensions => [:date])
  # pp Numbers::Report.query(:profile_id => 49739500, :metrics => [:pageviews, :visits, :avg_time_on_site], :dimensions => [:visitorType, :visitCount, :date])
end
