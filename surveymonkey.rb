#!/usr/bin/env ruby
require 'mechanize'

module SurveyMonkey
    
  # Class which can login to surveymonkey.com and scrape data
  class Account
    attr_reader :surveys
    
    def initialize(username, password)
      @agent = Mechanize.new
      login(username, password)
    end
    
    # Get surveys matching a filter
    def get_surveys(filter = /.*/)
      
      # Scrape index pages
      @agent.get "http://www.surveymonkey.com/MySurveys.aspx"
      @surveys = Array.new
      scrape_index(filter)
      @agent.page.links_with(:text => /^\d+$/).each do |page_link|
        page_link.click
        scrape_index(filter)
      end
      
      # Scrape detail pages
      @surveys.collect!.with_index do |s, i|
        puts "Scraping #{i+1}/#{@surveys.length} (#{(i+1)*100/@surveys.length}%)"
        Survey.new(s)
      end
    end
    
    private
    def login(username, password)
      @agent.get "http://www.surveymonkey.com/MyAccount_Login.aspx"
      @agent.page.form_with(:name => "frmLogin").tap do |login|
        login.field_with(:name => "wc_Login1$txtUsername").value = username
        login.field_with(:name => "wc_Login1$txtPassword").value = password
        login.add_field!("__EVENTTARGET", "wc_Login1$btnLogin")
      end.submit
    end
    
    def scrape_index(filter)
      @agent.page.links_with(:text => filter).each { |link| @surveys << link }
    end
  end
  
  # A surveymonkey.com survey
  class Survey
    attr_reader :name, :completed
    
    def initialize(link)
      @link = link
      scrape_detail
    end
    
    private
    def scrape_detail
      results = @link.click.link_with(:href => /_Responses.aspx/).click.link_with(:text => /view all pages/).click
      @name = @link.text  # Name
      @completed = results.search('//div[@id="panTotals"]/table/tr/td[2]/b').text   # Total Completed
    end
  end
  
end

sm = SurveyMonkey::Account.new("username", "password")
surveys = sm.get_surveys(/EWomen/)
surveys.each do |s|
  puts "--- #{s.name} ---"
  puts "# Completed: #{s.completed}"
end