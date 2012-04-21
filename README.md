# TimeEdit

Ruby bindings for TimeEdit

## How to use

### List all rooms

``` ruby
TimeEdit::Rooms.new({
  search: "ED4422"
}).results
# => [{
#   room: "ED4422",
#   id: "12345.186"
# }]
```

### List all bookings for a particular room

``` ruby
TimeEdit::Bookings.new({
  room: "ED4422",
  start_time: Time.now,
  end_time: 3.days.from_now
}).results
# => [{
#  from: Time.now
#  to: 45.minutes.from_now
# }]
```