class Album
	attr_accessor :name, :rank, :year

	def initialize(row)
		@name = row[1]
		@year = row[2]
		@rank = row[3]
	end
end