require 'spec_helper'

describe Conversation do
  # let(:customer1) { Fabricate(:user )}
  # let(:customer2) { Fabricate(:user) }
  # let(:quote) { Fabricate(:quote, user: customer1) }
  # let(:conversation) { Fabricate(:conversation, users: [customer1, customer2], conversable: quote) }

  # describe '.unread?' do
  #   it "knows if there are unread messages for user" do
  #     conversation.messages << Fabricate.build(:message, sender: customer1, body: 'First unread message from Customer')
  #     expect(conversation.unread?(customer2)).to be_true
  #     expect(conversation.unread?(customer1)).to be_false
  #   end
  # end

  # describe '.users_except' do
  #   it "returns all users except the provided one" do
  #     expect(conversation.users_except(customer2).size).to be 1
  #     expect(conversation.users_except(customer2).first).to be customer1
  #     expect(conversation.users_except(customer1).size).to be 1
  #     expect(conversation.users_except(customer1).first).to be customer2
  #     expect(conversation.users_except(nil).size).to be 2
  #     expect(conversation.users_except(nil).include?(customer1)).to be_true
  #     expect(conversation.users_except(nil).include?(customer2)).to be_true
  #   end
  # end

  # describe '.mark_as_read' do
  #   it "marks the conversation as read for provided user" do
  #     conversation.mark_as_read(customer2)
  #     expect(conversation.unread?(customer2)).to be_false
  #   end
  # end

  # describe '.last_unread_message' do
  #   it "returns the last unread message" do
  #     conversation.messages << Fabricate.build(:message, sender: customer1, body: 'First unread message from Customer')
  #     expect(conversation.last_unread_message(customer2).body).to eq 'First unread message from Customer'
  #     expect(conversation.last_unread_message(customer1)).to be_nil
  #     conversation.messages << Fabricate.build(:message, sender: customer1, body: 'Second unread message from Customer')
  #     expect(conversation.last_unread_message(customer2).body).to eq 'Second unread message from Customer'
  #     conversation.messages << Fabricate.build(:message, sender: customer2, body: 'First unread message from Customer2')
  #     expect(conversation.last_unread_message(customer1).body).to eq 'First unread message from Customer2'
  #   end
  # end

  # describe Message do
  #   describe '.unread?' do
  #     it "knows when message is unread" do
  #       message = Fabricate.build(:message, sender: customer1, body: 'First unread message from Customer')
  #       conversation.messages << message
  #       expect(message.unread?).to be_true
  #     end
  #   end
  # end
end
