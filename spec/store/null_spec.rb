require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe HTTPSession::Store::Null do
  before do
    @store = HTTPSession::Store::Null.new
  end

  it 'should return nil for select' do
    @store.select(:key).should == nil
  end

  it 'should return nil for insert' do
    @store.select(:key).should == nil
  end
end
