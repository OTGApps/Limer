# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/osx'
require 'bundler'

Bundler.setup
Bundler.require

Motion::Project::App.setup do |app|
  app.name = 'Limer'
  app.version = '0.0.1'
  app.short_version = '1'
  app.copyright = 'Copyright © 2013 Mohawk Apps, LLC. All rights reserved.'
  app.deployment_target = '10.7'
	app.identifier = 'com.mohawkapps.limer'
	app.icon = 'Limer.icns'

  app.info_plist['CFBundleDocumentTypes'] = [{
  	'LSApplicationCategoryType' => 'public.app-category.developer-tools'
  	}]
end
