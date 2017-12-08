require 'spec_helper'

describe QuoteObserver do
  describe 'on create' do
    it "asynchronously publishes on facebook timeline if requested by user" do
      expect(-> { Fabricate(:quote, share_on_facebook_timeline: true) }).to_not raise_error Exception
    end
  end
end
