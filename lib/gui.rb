# encoding: utf-8

require 'gtk2'

class Progreso
	attr_reader :por_ciento, :texto
	def initialize()
		@ventana = Gtk::Window.new(Gtk::Window::TOPLEVEL)
		@ventana.resizable = true
		@ventana.set_title  "Barra de progreso"
		@ventana.border_width = 10
		@ventana.signal_connect('delete_event') { detener(); false }
		@ventana.signal_connect('destroy') { detener() }
		@ventana.set_size_request(-1, -1)

		@alineación = Gtk::Alignment.new(0.5, 0.5, 0.0, 0.0)
		@barra = Gtk::ProgressBar.new
		@alineación.add(@barra)

		@botón = Gtk::Button.new("Cancelar")
		@botón.signal_connect('clicked') { detener() }

		@hq = Gtk::HBox.new(false, 5)
		@hq.border_width = 10
		@hq.pack_start(@alineación, false, false, 5)
		@hq.pack_start(@botón, false, false, 5)

		@ventana.add(@hq)
		@ventana.show_all
		
		@por_ciento = 0.0 / 100.0
	end
	
	def salir(msg="Equivocación")
		self.pulsar(0.0/100.0, msg)
		STDERR.write(msg)
		sleep(5)
		Gtk.main_quit
	end

	def detener()
		Gtk.main_quit
	end
	
	def pulsar(progreso, msg=false)
		@por_ciento += progreso / 100.0
		if @por_ciento > 100
			@por_ciento = 100.0 / 100.0
		end
		@barra.text = msg || "%.0f%% Completado" % @por_ciento
		@texto = @barra.text
		@barra.fraction = @por_ciento
	end
end
