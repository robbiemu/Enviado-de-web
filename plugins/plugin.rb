STDOUT.flush()

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
		sleep(i)
		p i
	end
	def b(i)
		sleep(i)
		p "#{i} at b"
	end
	def c(i)
		sleep(i)
		i +=2
		p i
	end
end
