require 'test_helper'

class NotificationTest < ActionMailer::TestCase
  test "new_account" do
    @expected.subject = 'Notification#new_account'
    @expected.body    = read_fixture('new_account')
    @expected.date    = Time.now

    assert_equal @expected.encoded, Notification.create_new_account(@expected.date).encoded
  end

end
