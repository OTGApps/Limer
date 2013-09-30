class AppDelegate
  def applicationDidFinishLaunching(notification)
    detect_files_and_launch_sublime
  end

  def buildWindow
    @mainWindowController = MainWindow.alloc.initWithWindowNibName('MainWindow')
    @mainWindowController.window.makeKeyAndOrderFront(self)
  end

  def detect_files_and_launch_sublime
    NSLog("Found Finder: %@", finder)

    @sublime = find_sublime_app

    alert("Can't Find Sublime Text", "It looks like Sublime Text isn't installed on your computer.", true) unless @sublime

    if finder.isRunning
      NSLog("Finder is running")
      NSLog("Selection: %@", finder.selection);
      NSLog("Selection Methods: %@", finder.selection.methods);

      selection = finder.selection.get
      NSLog("Limer Selected: %@", selection)
      alert("Well, Shoot!", "There was a problem getting the selected files from Finder. Sandboxing problem, perhaps?", "true") if selection.nil?

      if selection.count <= 0
        # Nothing is selected in Finder, get the topmost window's path.
        selection = [finder.windows.arrayByApplyingSelector("target").first]
        NSLog("Selected Path: %@", selection)
      end

      open_sublime selection
    else
      alert "Is Finder running?", "It looks like Finder isn't running. This application must be launched with Finder running.", true
    end
  end

  def finder
    @finder ||= SBApplication.applicationWithBundleIdentifier("com.apple.Finder")
  end

  def find_sublime_app
    two = "com.sublimetext.2"
    three = "com.sublimetext.3"

    sublime = SBApplication.applicationWithBundleIdentifier(three)
    @sublime_key = three
    if !sublime
      sublime = SBApplication.applicationWithBundleIdentifier(two)
      @sublime_key = two
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
