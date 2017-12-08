require 'spec_helper'

describe User do
  let(:user) { Fabricate(:user) }
  let(:male_user) { Fabricate(:user, gender: 'male') }
  let(:female_user) { Fabricate(:user, gender: 'female') }

  describe '.age' do
    let(:born_on_1960_10_30) { Fabricate(:user, birthday: '1960-10-30') }
    let(:born_on_1972_02_29) { Fabricate(:user, birthday: '1972-02-29') }
    let(:unknown_birthday) { Fabricate(:user, birthday: nil) }

    it "returns user's age" do
      Delorean.time_travel_to '2011-02-28'
      expect(born_on_1972_02_29.age).to be 38
      Delorean.time_travel_to '2011-03-01'
      expect(born_on_1972_02_29.age).to be 39
      Delorean.time_travel_to '2012-02-28'
      expect(born_on_1972_02_29.age).to be 39
      Delorean.time_travel_to '2012-02-29'
      expect(born_on_1972_02_29.age).to be 40

      Delorean.time_travel_to '2012-10-29'
      expect(born_on_1960_10_30.age).to be 51
      Delorean.time_travel_to '2012-10-30'
      expect(born_on_1960_10_30.age).to be 52
    end

    it "does not raise exceptions if user has no birthday" do
      expect(unknown_birthday.age).to be_nil
    end
  end

  describe '.first_name' do
    let(:caner_cakmak) { Fabricate(:user, name: 'Caner Cakmak') }
    let(:anonymous) { Fabricate(:user, name: nil) }

    it "returns user's first name" do
      expect(caner_cakmak.first_name).to eq 'Caner'
    end

    it "does not raise exceptions if user has no name" do
      expect(anonymous.first_name).to be_nil
    end
  end

  describe '.to_s' do
    let(:caner_cakmak) { Fabricate(:user, name: 'Caner Cakmak') }
    let(:anonymous) { Fabricate(:user, name: nil) }

    it "returns user's name when available" do
      expect(caner_cakmak.to_s).to eq 'Caner Cakmak'
      expect(anonymous.to_s).to eq anonymous.id
    end

    it "does not raise exceptions if user has no name" do
      expect(anonymous.first_name).to be_nil
    end                                                   
  end
 
  describe "#verify_phone" do
    let(:phone) {"05322814785"}
    it "updates attributes" do
      expect(user.update_attributes!(telephone: phone, phone_verified: true)).to be_truthy
    end
  end

  describe '.to_param' do
    let(:canercakmak) { Fabricate(:user, username: 'canercakmak', uid: '123456') }
    let(:uid123456) { Fabricate(:user, username: nil, uid: '123456' )}
    let(:anonymous) { Fabricate(:user, username: nil, uid: nil) }

    it "returns username when all fields are available" do
      expect(canercakmak.to_param).to eq canercakmak.username
    end

    it "returns uid when username is not available" do
      expect(uid123456.to_param).to eq uid123456.uid
    end

    it "fallbacks to id when neither the username nor the uid is available" do
      expect(anonymous.to_param).to eq anonymous.id
    end
  end

  describe '.profile_picture' do
    it "returns facebook profile picture of type square (by default)" do
      expect(user.profile_picture).to eq "https://graph.facebook.com/#{user.uid}/picture?type=square"
    end
  end

  describe '.male?' do
    it "answers true if user is male" do
      expect(male_user).to be_truthy
    end

    it "answers false if user is male" do
      expect(female_user).to be_falsey
    end
  end

  describe '.female?' do
    it "answers true if user is female" do
      expect(female_user).to be_truthy
    end

    it "answers false if user is male" do
      expect(male_user).to be_falsey
    end
  end
end
