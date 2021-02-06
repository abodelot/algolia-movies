require 'rails_helper'

RSpec.describe Movie do
  let(:actor) { FactoryBot.build(:actor) }

  describe 'validations' do
    it 'validates name is unique' do
      actor.name = 'Bruce Lee'
      actor.save!

      actor_2 = FactoryBot.build(:actor, name: 'Bruce Lee')
      expect(actor_2).to be_invalid
    end

    it 'validates image is a URL' do
      actor.image = 'https://host/pic.png'
      expect(actor).to be_valid

      actor.image = 'http://host/path/to/image.jpg'
      expect(actor).to be_valid

      actor.image = ''
      expect(actor).to be_invalid

      actor.image = 'xxx\yyyy'
      expect(actor).to be_invalid
    end
  end
end
