module SurveyMonkey
  
  # A surveymonkey.com survey
  class Survey
    attr_reader :name, :started, :completed
    
    def initialize(link)
      @link = link
      results = @link.click.link_with(:href => /_Responses.aspx/).click.link_with(:text => /view all pages/).click
      @name = @link.text  # Name
      @started = results.search('#panTotals b')[1].text   # Total started
      @completed = results.search('#panTotals b')[3].text.sub(/\s*\(.*$/,'')   # Total completed
    end
  end

end