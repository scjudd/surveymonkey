module SurveyMonkey
  
  class Question
    attr_reader :question
    
    def initialize(table)
      @question = table.search('.notranslate').first.text.sub(/^\d+\.\s+/, '')
    end
  end

end