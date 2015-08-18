require 'rails_helper'

RSpec.describe AdvancedStoryFormatter do
  it 'sets an default name and body when initialized' do
    new_obj = described_class.new
    expect(new_obj.name).to eql(new_obj.initial_name)
    expect(new_obj.body).to eql(new_obj.initial_body)
  end

  it 'uses passed in values over the defaults' do
    new_obj = described_class.new(name: 'foobar', body: 'baz')
    expect(new_obj.name).to eql('foobar')
    expect(new_obj.body).to eql('baz')
  end
end
