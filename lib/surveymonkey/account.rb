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
      raise SurveyMonkey::LoginError if @agent.page.body.match('Authentication failed')
    end
    
    def scrape_index(filter)
      @agent.page.links_with(:text => filter).each { |link| @surveys << link }
    end
  end

end