As a member, when I have enough personal informations.
I should be able to create a shop.
So that I can manage my products,
Another user will be easier find my produc by go to my shop page
My friend will be able to post banner on my shop, and I also be able to put my banner on their shop
Shopper will be able to see all my products when they go to my shop page.
I will be able to have some promotion events for my client

Story: Creating a shop
    As a logged in user
    When I have enough personal infomations
    I should be able to create a shop

    Scenario: A logged in user go to create a shop
      Given reggie is logged in
       And  I have enough personal infomations
       When I go to /my_account
       And  I should see "Create Shop" button
