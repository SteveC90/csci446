class Album
	attr_accessor :name, :rank, :year

	def initialize(string, r)
		t = string.split(',')
		@name = t[0].strip
		@year = t[1].strip
		@rank = r
	end
end