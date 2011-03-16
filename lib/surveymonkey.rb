require 'mechanize'

module SurveyMonkey
  
  # All exceptions raised are a subclass of this class.
  # Allows one to catch SurveyMonkey::Error
  class Error < Exception
  end

  # This exception is raised when login fails
  class LoginError < Error
    def initialize
      super "Login failed. Check username and password."
    end
  end
  
  autoload :Account, "surveymonkey/account"
  autoload :Survey,  "surveymonkey/survey"
end