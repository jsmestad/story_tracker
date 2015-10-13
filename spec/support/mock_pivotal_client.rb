class MockPivotalClient < TrackerProject
  def create_story(*args)
    OpenStruct.new(id: SecureRandom.random_number(1000000))
  end

end
