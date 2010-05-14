class Plugin
	@internal_methods=[]
	def initialize(fh)
	end
	def ordenes()
		return [lambda {|*i| self.a(*i) },lambda {|*i| self.c(*i) },lambda {|*i| self.b(*i) }]
	end
	def a(i)
		if i.nil?
			i = 0
		end
		i +=1
		p i
	end
	def b(i)
		p i + " at b"
	end
	def c(i)
		i +=2
		p i
	end
end
