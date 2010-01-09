Given /^(?:|I ) have enough personal infomation$/ do
  controller.current_user.should be_enough_info
end