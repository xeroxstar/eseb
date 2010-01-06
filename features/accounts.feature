Visitors should be in control of creating an account and of proving their
essential humanity/accountability or whatever it is people think the
id-validation does.  We should be fairly skeptical about this process, as the
identity+trust chain starts here.

Story: Creating an account
  As an anonymous user
  I want to be able to create an account
  So that I can be one of the cool kids

  #
  # Account Creation: Get entry form
  #
  Scenario: Anonymous user can start creating an account
    Given an anonymous user
    When  she goes to /signup
    Then  she should be at the 'users/new' page
     And  the page should look AWESOME
     And  she should see a <form> containing a textfield: Login, textfield: Email, password: Password, password: 'Confirm Password', submit: 'Sign up'

  #
  # Account Creation
  #
  Scenario: Anonymous user can create an account
    Given an anonymous user
     And  no user with login: 'Oona' exists
    When  she registers an account as the preloaded 'Oona'
    Then  she should be redirected to the home page
    When  she follows that redirect!
    Then  a user with login: 'oona' should exist
     And  the user should have login: 'oona', and email: 'unactivated@example.com'


  #
  # Account Creation Failure: Account exists
  #


  Scenario: Anonymous user can not create an account replacing an activated account
    Given an anonymous user
     And  an activated user named 'Reggie'
     And  we try hard to remember the user's updated_at, and created_at
    When  she registers an account with login: 'reggie', password: 'monkey', and email: 'reggie@example.com'
    Then  she should be at the 'users/new' page
     And  she should     see an errorExplanation message 'Login has already been taken'
     And  she should not see an errorExplanation message 'Email has already been taken'
     And  a user with login: 'reggie' should exist
     And  the user should have email: 'registered@example.com'

     And  the user's created_at should stay the same under to_s
     And  the user's updated_at should stay the same under to_s
     And  she should not be logged in

  #
  # Account Creation Failure: Incomplete input
  #
  Scenario Outline: Anonymous user can not create a account with invalid value
    Given an anonymous user
      And no user with login: '<login>' exists
     When I registers an account with login: '<login>', password: '<password>', password_confirmation: '<password_confirmation>' and email: '<email>'
     Then I should be at the 'users/new' page
     And  I should     see an errorExplanation message '<error_explantion_message>'
     And  no user with login: '<login>' should exist
     Examples: Invailid Email
       |  login    |  password   |  password_confirmation  | email         |   error_explantion_message                  |
       |  quydoan  |  maiyeuem   |    maiyeuem             | quydoan-a)@   |      Email should look like an email address|
       |  quydoan  |  yeuem1EW2  |    yeuem1EW2            |               |      Email can't be blank                   |
     Examples: Password does not match
       |  login    |  password   |  password_confirmation  | email         |   error_explantion_message                  |
       |  quydoan  |  maiyeuem1232|    maiyeuem             | quydoantran@gmail.com   |      Password doesn't match confirmation|
       |  quydoan  |  maiyeuem1232|    yeuem1EW2            | quydoantran@gmail.com   |      Password doesn't match confirmation|
       |  quydoan  |              |    yeuem1EW2            | quydoantran@gmail.com   |      Password can't be blank|
       |  quydoan  |  yeuem1EW2   |                         | quydoantran@gmail.com   |      Password confirmation can't be blank|
     Examples: Invailid login
       |  login    |  password    |  password_confirmation  | email                   |   error_explantion_message         |
       |           |  maiyeuem1232|    maiyeuem1232         | quydoantran@gmail.com   |      Login can't be blank          |

  Scenario: Account Activation
    Given an anonymous user
     And  no user with login: 'Oona' exists
     When I registers an account with login: 'oona', password: 'maiyeuem', password_confirmation: 'maiyeuem' and email: 'quydoantran@gmail.com'
     Then "quydoantran@gmail.com" should receive an email
     And  "quydoantran@gmail.com" should have 1 email
     And I should receive an email with a link to a activate page

    Given an anonymous user
     When I registers an account with login: 'reggie', password: 'monkey', and email: 'reggie@example.com'
     Then "reggie@example.com" should have no email
