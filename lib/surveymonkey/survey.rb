module SurveyMonkey
  
  # A surveymonkey.com survey
  class Survey
    attr_reader :name, :started, :completed, :questions
    
    def initialize(link)
      results = link.click.link_with(:href => /_Responses.aspx/).click.link_with(:text => /view all pages/).click
      @name = link.text  # Name
      @started = results.search('#panTotals b')[1].text   # Total started
      @completed = results.search('#panTotals b')[3].text.sub(/\s*\(.*$/,'')   # Total completed
      
      # Scrape questions
      @questions = Array.new
      results.search('.rsltsmry').each do |q|
        @questions << Question.new(q)
      end
    end
  end

end