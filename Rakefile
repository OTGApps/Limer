# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
# $:.unshift("/Library/RubyMotion2.8/lib")
require 'motion/project/template/osx'

begin
  require 'bundler'
  Bundler.setup
  Bundler.require
rescue LoadError
end

Motion::Project::App.setup do |app|
  app.name = 'Limer'
  app.version = '1.0.0'
  app.short_version = '1'
  app.copyright = '© 2013 Mohawk Apps, LLC.'
  app.sdk_version = "10.8"
  app.deployment_target = "10.8"
	app.identifier = 'com.mohawkapps.limer'
	app.icon = 'Limer.icns'
	app.frameworks += %w(ScriptingBridge)
  app.category = 'developer-tools'
  app.entitlements['com.apple.security.app-sandbox'] = true

  app.release do
    app.codesign_certificate = "3rd Party Mac Developer Application: Mohawk Apps, LLC (DW9QQZR4ZL)"
  end

end
