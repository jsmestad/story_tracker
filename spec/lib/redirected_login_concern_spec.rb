require 'spec_helper'

RSpec.describe RedirectedLoginConcern do

  let(:test_class) do
    class MockController
      include RedirectedLoginConcern
    end
  end

  subject(:controller_instance) { test_class.new }

  describe 'remember_location!' do
    it 'stores the full url and params when present' do
      expect(controller_instance.remember_location!('http://google.com/foo/bar', {})).to eql({referrer: 'http://google.com/foo/bar'})
      expect(controller_instance.remember_location!('https://google.com/', {})).to eql({referrer: 'https://google.com/'})
      expect(controller_instance.remember_location!('https://google.com/?q=place#baz', {})).to eql({referrer: 'https://google.com/?q=place#baz'})
    end

    it 'ignores things that are not a HTTP/HTTPS' do
      expect(controller_instance.remember_location!('asdf', {})).to eql({})
      expect(controller_instance.remember_location!('ftp://127.0.0.1/foo/bar', {})).to eql({})
    end
  end

  describe '#stored_location' do
    it 'ignores things that are not a HTTP/HTTPS' do
      expect(controller_instance.stored_location({referrer: 'asdf'})).to be_nil
      expect(controller_instance.stored_location({referrer: 'ftp://127.0.0.1/foo/bar'})).to be_nil
    end

    it 'returns the stored value' do
      expect(controller_instance.stored_location({referrer: 'http://google.com/foo/bar'})).to eql('/foo/bar')
      expect(controller_instance.stored_location({referrer: 'http://google.com/'})).to eql('/')
      expect(controller_instance.stored_location({referrer: 'http://google.com/?q=place'})).to eql('/?q=place')
      expect(controller_instance.stored_location({referrer: 'http://google.com/?q=place#anchor'})).to eql('/?q=place#anchor')
    end

    it 'removes the returned value from the hash' do
      params_hash = {referrer: 'http://www.foobar.local/foo/bar'}

      expect {
        expect(controller_instance.stored_location(params_hash)).to eql('/foo/bar')
      }.to change { params_hash.has_key?(:referrer) }.from(true).to(false)
    end

    it 'returns nil if not present' do
      expect(controller_instance.stored_location({})).to be_nil
    end
  end

end

