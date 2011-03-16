module SurveyMonkey
  
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