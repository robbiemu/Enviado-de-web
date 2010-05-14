#!/usr/bin/env ruby
# encoding: utf-8

require 'unicode'

require "lib/browser"
require "lib/gui"

fase=0.0/100.0

Thread.abort_on_exception = true

g = Progreso.new()
gui = Thread.new do
	loop do
		Gtk.main_iteration while Gtk.events_pending?
		g.pulsar(fase)
	end
end

Kernel.trap('INT') { g.detener(); exit 1 }
Kernel.trap('SIGINT') { g.detener(); exit 1 }

unless ARGV[1]
	g.salir("No hay ningún archivo para enviar. Sale...")
	exit 2
end
archivo=ARGV[1].sub( /file:\/\//, "" )

pa = File.expand_path("plugins/#{$0}")
pa = pa.force_encoding(pa.encoding) # ruby 1.9.1 hack
nc = $0
nc = nc.sub(/^.*[\.\/]\/([^\/]+)/, '\1')
nc = Unicode.upcase( nc[0] ) + nc[1..-1] # ruby 1.9.1 hack
begin
	require pa
rescue
	g.salir("No hay módulo #{pa} que usarse en la carpeta de plugins")
	exit 3
end
		
begin
	Módulo = Object.const_get( nc )
rescue
	g.salir("Módulo #{pa} en 'plugins' sin class de nombre '#{nc}'")
	exit 3
end

trabajo = Thread.new do
		p "."
	e = BrowserEnviado.new()
	b = Progreso.new()

	m = Módulo.new(archivo)
	ordenes = m.ordenes()
	paso = 1.0 / (ordenes.length + 2)
	fase = paso
	url = nil
	ordenes.each do |orden|
		url, *args = orden.call( url )
		fase += paso
		case url.class
		when Fixnum
			g.salir(args[0])
			exit url
		when String
			g.pulsar(fase, url)
		when Array
			g.pulsar(url[0], url[1])
		end
	end
	e.enviar( url )
end
trabajo.join
g.detener()
