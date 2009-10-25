#############################################################################
# Copyright © 2009 Dan Wanek <dan.wanek@gmail.com>
#
#
# This file is part of Facebooker-extensions.
# 
# Facebooker-extensions is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as published
# by the Free Software Foundation, either version 3 of the License, or (at
# your option) any later version.
# 
# Facebooker-extensions is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General
# Public License for more details.
# 
# You should have received a copy of the GNU General Public License along
# with Facebooker-extensions.  If not, see <http://www.gnu.org/licenses/>.
#############################################################################
require 'rubygems'
require 'mechanize'
require 'highline/import'

# This file contains various extentions to the Facebooker::Session classes
# and modules.
module Facebooker
	class Session
		class Desktop

			# This methods allows you to login to facebook without having to 
			# open a GUI.  It uses the "mechanize" gem to process the login
			# form and the 'highline' gem to prompt for user input.
			def do_login
				user = ask("Login:  ") { |q| q.echo = true }
				pass = ask("Password:  ") { |q| q.echo = "*"}
				agent = WWW::Mechanize.new
				page = agent.get( login_url )
				form = page.forms.first
				form['email'] = user
				form['pass']  = pass
				resp = form.submit
			end

			# ----------------- Private Methods ----------------- #
			private
			
			# This overides a method in facebooker/session.rb to fix an issue that causes
			# the error "Incorrect signature (Facebooker::Session::IncorrectSignature)" to
			# ocurr.  Many thanks to "TheFamilyGuy":
			# http://groups.google.com/group/facebooker/browse_thread/thread/826492e36622d113/ee22c70f68b3b6f8?lnk=gst&q=Desktop#ee22c70f68b3b6f8
			def add_facebook_params(hash, method)
				hash[:method] = method
				hash[:api_key] = @api_key
				hash[:call_id] = Time.now.to_f.to_s unless method == 'facebook.auth.getSession'
				hash[:v] = "1.0"
				# Added this to the original method
				hash[:session_key] = @session_key
			end
		end
	end
end

