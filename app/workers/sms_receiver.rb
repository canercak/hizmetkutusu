require 'resque-scheduler'
class SmsReceiver
  include UsersHelper
  include ApplicationHelper
 @queue = :incoming_sms_queue
  def self.perform
    sms_receiver= Sms.new
    sms_receiver.check_incoming_sms
  end
end
