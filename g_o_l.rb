require('pry')

class World

  def initialize(size)
    @map = []
    @size = size

    @size.times do |y|
      row = []
      @size.times do |x|
        pixel = Pixel.new([x,y], self)
        row << pixel
      end
      @map << row
    end
  end

  def life
    1000.times do
      self.display
      self.evolve
    end
  end

  def display
    @map.each do |row|
      row.each do |pixel|
        print "#{pixel.display_state}"
        # print "#{pixel.living_neighbor_counter}"
      end

      puts ""
    end
    sleep 0.3
    puts `clear`
  end

  def evolve
    @new_map = []

    @map.each do |row|
      new_row = []

      row.each do |pixel|
        next_state = pixel.next_state
        new_row << Pixel.new(pixel.location, self, next_state)
      end

      @new_map << new_row
    end

    # set the new map
    @map = @new_map
  end

  def alive?(location)
    x, y = *location

    return false if x < 0 || y < 0

    row = @map[x]
    return false if row.nil?
    cell = row[y]
    return false if cell.nil?

    cell.state
  end
end

class Pixel

  attr_reader :state, :location, :world

  def initialize(location, world, state = nil)
    @location = location
    @world = world
    # @state = [true, false, false, false, false].sample
    @state = if state.nil?
      [true, false, false].sample
    else
      state
    end
  end

  def display_state
    state ? print("  ") : print("  ")
  end

  def living_neighbor_counter
    @living_neighbor_counter = 0

    neighbors.each do |neighbor|
      if world.alive?(neighbor)
        @living_neighbor_counter +=1
      end
    end

    self_alive = world.alive?(self.location)

    if self_alive
      @living_neighbor_counter - 1
    else
      @living_neighbor_counter
    end

  end

  def neighbors
    temp_neighbors = []
    x_range = (((self.location[0])-1)..((self.location[0])+1))
    y_range = (((self.location[1])-1)..((self.location[1])+1))
    y_range.each() do |y|
      x_range.each() do |x|
        temp_neighbors << [x, y]
      end
    end
    temp_neighbors
  end

  def next_state
    if @state
      #if alive
      if living_neighbor_counter < 2 || living_neighbor_counter > 3
        false
      else
        true
      end
    else
      #if dead
      if living_neighbor_counter == 3
        true
      else
        false
      end
    end
  end

private

end

puts "Hello its working"

world = World.new(30)
world.life
