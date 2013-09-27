class AppDelegate
  def applicationDidFinishLaunching(notification)
    detect_files_and_launch_sublime
  end

  def buildWindow
    @mainWindowController = MainWindow.alloc.initWithWindowNibName('MainWindow')
    @mainWindowController.window.makeKeyAndOrderFront(self)
  end

  def detect_files_and_launch_sublime
    finder = SBApplication.applicationWithBundleIdentifier("com.apple.Finder")
    # NSLog("Found Finder: %@", finder)

    @sublime = find_sublime_app

    unless @sublime
      alert "Can't Find Sublime Text", "It looks like Sublime Text isn't installed on your computer.", true
    end

    if finder.isRunning
      selection = finder.selection.get
      NSLog("Limer Selected: %@", selection)

      if selection.count <= 0
        # Nothing is selected in Finder, get the topmost window's path.
        selection = [finder.windows.arrayByApplyingSelector("target").first]
        # NSLog("Selected Path: %@", selection)
      end

      open_sublime selection
    else
      alert "Is Finder running?", "It looks like Finder isn't running. This application must be launched with Finder running.", true
    end
  end

  def find_sublime_app
    sublime = SBApplication.applicationWithBundleIdentifier("com.sublimetext.3")
    @sublime_key = "com.sublimetext.3"
    if !sublime
      sublime = SBApplication.applicationWithBundleIdentifier("com.sublimetext.2")
      @sublime_key = "com.sublimetext.2"
    end
    sublime
  end

  def open_sublime(with_files_folders)
    @sublime ||= find_sublime_app

    workspace = NSWorkspace.sharedWorkspace
    converted = convert_to_urls with_files_folders

    if contains_limer? converted
      # Show the main window
      buildMenu
      buildWindow
    else
      workspace.openURLs(converted, withAppBundleIdentifier:@sublime_key, options:NSWorkspaceLaunchDefault, additionalEventParamDescriptor:nil, launchIdentifiers:nil)
      go_kill_yourself
    end

  end

  def contains_limer?(files_folders)
    files_folders.each do |ff|
      return true if ff.lastPathComponent == "#{NSBundle.mainBundle.infoDictionary['CFBundleName']}.app"
    end
    false
  end

  def convert_to_urls(files_folders)
    converted = []
    files_folders.each do |ff|
      converted << NSURL.URLWithString(ff.URL)
    end
    converted
  end

  def alert(title, message, kill_yourself = false)
    alert = NSAlert.alloc.init
    alert.setAlertStyle(NSInformationalAlertStyle)
    alert.setMessageText(title)
    alert.setInformativeText(message)
    alert.runModal
    go_kill_yourself if kill_yourself
  end

  def go_kill_yourself
    # It doesn't get better.
    NSApplication.sharedApplication.terminate(nil)
  end

  def applicationShouldTerminateAfterLastWindowClosed(app)
    true
  end

end
