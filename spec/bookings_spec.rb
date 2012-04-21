describe TimeEdit::Bookings do
  use_vcr_cassette "requests"

  let(:from) { Date.parse "20120312" }
  let(:to) { Date.parse "20120518" }
  let(:rooms_mock) { mock(Object.new) }

  subject {
    TimeEdit::Bookings.new({
      room: "4207",
      start_time: from,
      end_time: to,
      rooms: rooms_mock
    })
  }

  before(:each) do
    TimeEdit::Rooms.should_not_receive(:new)
    rooms_mock.should_receive(:lookup_room).with("4207").and_return("192324.186")
  end

  it "should return a list of bookings" do
    should have(50).results
  end

  it "should only contain valid bookings" do
    subject.results.each do |r|
      r[:from].should be_instance_of(Time)
      r[:to].should be_instance_of(Time)
      r.keys.should include(:to, :from)
      r[:to].should > r[:from]
      from.to_time.should <= r[:from]
      from.to_time.should <= r[:to]
      to.next.to_time.should > r[:from]
      to.next.to_time.should > r[:to]
    end
  end

  it "can find if current is ready and exists" do
    t = Time.parse("2012-05-08 14:00:00.000000000 +02:00")
    subject.ready(t).to_i.should eq (3*3600)
  end

  it "can find if current is no exist" do
    t = Time.parse("2012-05-05 15:00:00.000000000 +02:00")
    subject.ready(t).should be_nil
  end
end
