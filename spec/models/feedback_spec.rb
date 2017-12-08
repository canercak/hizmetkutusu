require 'spec_helper'

describe Feedback do
  describe '.fixed' do

    it "returns true if the status is feedback is fixed" do
      fixed_feedback = Fabricate(:feedback, status: 'fixed')
      open_feedback = Fabricate(:feedback)

      expect(fixed_feedback.fixed?).to be_truthy
      expect(open_feedback.fixed?).to be_falsey
    end
  end
end
