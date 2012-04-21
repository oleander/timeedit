module TimeEdit
  class Rooms
    attr_reader :results

    # Create object and fetch all rooms
    def initialize(params={})
      @term = params[:search]
      @results = fetch_all
      @dictionary = Hash[@results.map { |x| [x[:room], x[:id]] }]
    end

    # Create object and fetch all rooms
    def lookup_room(room)
      @dictionary[room]
    end

    private
    # Fetch all rooms
    def fetch_all
      list = []
      start = 0
      while true
        delta = fetch_range(start, MAX_NUM_ROOMS_FETCH)
        start += delta.size
        list.concat(delta)
        break if delta.size < MAX_NUM_ROOMS_FETCH
      end
      list
    end

    MAX_NUM_ROOMS_FETCH = 20

    def url(start, max)
      %W{
        https://web.timeedit.se/chalmers_se/db1/public/objects?
        max=#{max}&
        fr=t&
        partajax=t&
        im=f&
        sid=3&
        l=sv&
        types=186&
        start=#{start}&
        part=t&
        media=html&
        search_text=#{@term}
      }.join("")
    end

    def fetch_range(start, max)
      data = RestClient.get(url(start, max))
      doc = Nokogiri::HTML(data)

      selectors = ".clickable2.searchObject.noexpand"
      rooms = doc.css(selectors).map do |row|
        {
          room: row.to_s.match(%r{data-name="(.+?)"}).to_a[1],
          id: row.to_s.match(%r{data-id="(.+?)"}).to_a[1]
        }
      end
    end

  end
end


