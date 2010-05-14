# encoding: utf-8

require 'rubygems'
require 'mechanize'

class BrowserEnviado
	attr :browser
	def initialize(browser=["/usr/bin/env", "firefox"])
		@browser = browser
	end

	def enviar(url)
		if @browser.nil? or url.class != String
			return
		end
		system(*BROWSER, url)
	end
end

