module TimeEdit
  class Bookings
    #
    # @args[:room] String The room for which 
    #   we should list all bookings
    # @args[:start_time] Time Start time
    # @args[:end_time] Time End time
    #
    def initialize(args)
      @from = args[:start_time]
      @to = args[:end_time]
      @room = args[:room]
      @rooms = args[:rooms]
      @results = process
    end

    # @return     
    def ready(time)
      @results.each { |h|
        return h[:to]-time if h[:from] < time && time < h[:to]
      }
      return nil
    end

    #
    # @return [{ from: Time.now, to: 45.minutes.from_now }]
    #
    attr_reader :results

    private
    def process
      csv = RestClient.get(url).
        match(%r{(https://web\.timeedit\.se/chalmers_se/db1/public/r\.csv\?base=\w+)}).to_a[1]
      data = RestClient.get(csv).gsub(/"/, "'")
      rows = CSV.parse(data)
      return rows[4..-1].map do |row|
        {
          from: Time.parse("#{row[0]} #{row[1]}"),
          to: Time.parse("#{row[2]} #{row[3]}")
        }
      end
    end

    def id
      @rooms.lookup_room(@room)
    end

    def url
      %w{
        https://web.timeedit.se/chalmers_se/db1/public/r.html?
        sid=3&
        h=t&
        p=%s.x,%s.x&
        objects=%s&
        ox=0&
        types=0&
        fe=0
      }.join("") % [@from.strftime("%Y%m%d"), @to.strftime("%Y%m%d"), id]
    end
  end
end
