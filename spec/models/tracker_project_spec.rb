require 'rails_helper'

RSpec.describe TrackerProject do
  it 'can find a project by id' do
    project = described_class.new(project_id: 123)
    expect(project.project_id).to eql(123)
  end

  it 'accepts a custom api token' do
    project = described_class.new(api_token: 'abc')
    expect(project.api_token).to eql('abc')
  end

  it 'has a default project, if none specified' do
    project = described_class.new
    expect(project.project_id).to eql(ENV['DEFAULT_TRACKER_PROJECT'])
    expect(project.project_id).to_not be_empty
  end
end
