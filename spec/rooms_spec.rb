describe TimeEdit::Rooms do
  use_vcr_cassette "rooms"

  it "should be true" do
    true.should be_true
  end

  it "should return valid results" do
    res = TimeEdit::Rooms.new.results
    res.first.keys.should include(:room, :id)
  end

  it "a search term does alter result" do
    res = TimeEdit::Rooms.new(search: "HB").results
    res.should_not be_empty
    res.each { |h| h[:room].should include("HB") }
  end

  it "can loookup rooms" do
    res = TimeEdit::Rooms.new
    res.results.each do |h|
      res.lookup_room(h[:room]).should eq h[:id]
    end
  end
end
