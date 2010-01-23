Story: Edit, update user infomations
  As a user
  I should be able to edit and modify my infomation
  So that others shopper will be easier to contact with me
  And will be able to create a shop when I have enought infos also.

  Scenario: not login user try to go to edit_info page
    Given an anonmynous user
     When I go to /users/edit_info
     Then I shoud be at '/login' page

  Scenario: login user
    Given an activated user logged in as 'quydoan'
     When I go to /users/edit_info
     Then I should see edit_info form

  Scenario: login user as shop owner
    Given an activated user logged in as 'quydoan'
     And  I am a shop owner
    Then  I should see edit_info form
     And  I should see "edit shop" link

 Scenario: not login user try to go to update user
    Given an anonmynous user
    When I try to update user
    Then I should be at '/login' page

 Scenario: logined user try to update info of another
    Given an activated user logged in as 'quydoan'
    When I try to update infomations for account 'reggie'
    Then I should go to '/no_permission' page

 Scenario: logined user update his account with valid data
    Given an activated user logged in as 'quydoan'
    When I update my info with valid data
    Then I should see 'update successful'