Feature: become a mentor
  As a mentee
  so that I can choose to become a mentor

Background: logined user
  Given the following users exist:
    |username |     email       |lastname|role  |
    |Test_user|test@berkeley.edu|Test    |mentee|
  Given I am successfully signin with "test@berkeley.edu"
  
Scenario: Able to become a mentor for a mentee
  Given I am on the home page
  Then I should see "BecomeMentor"
  When I follow "BecomeMentor"
  And I fill in "Company" with "Google"
  And I fill in "Position" with "Software Development Engineer"
  And I fill in "Helpability" with "Resume, Advice"
  And I press "Update"
  Then I should see "Google"
  And I should see "Software Development Engineer"
  And I should see "Resume, Advice"