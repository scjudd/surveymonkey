surveymonky
===========

A ruby library to scrape surveys from surveymonkey.com

Example
-------

```ruby
require 'surveymonkey'

sm = SurveyMonkey::Account.new("username", "password")
surveys = sm.get_surveys
surveys.each do |s|
  puts "--- #{s.name} ---"
  puts "# Started:   #{s.started}"
  puts "# Completed: #{s.completed}"
  puts "Questions: "
  s.questions.each.with_index do |q, i|
    puts "  #{i+1}: #{q.question}"
  end
end
```
