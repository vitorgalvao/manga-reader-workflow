import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
  func applicationDidFinishLaunching(_ aNotification: Notification) {
    // If launched directly, show a message and quit
    showQuitDialog("This is a helper app for file associations. Do not open it directly, open files with it.")
  }

  func application(_ application: NSApplication, open urls: [URL]) {
    // Properly percent encode before making URL to sent to Alfred
    guard let encodedPath = urls[0].path.addingPercentEncoding(withAllowedCharacters: .alphanumerics) else {
      return showQuitDialog("Failed to encode path: ")
    }

    // Build the Alfred URL scheme
    let alfredURLString = "alfred://runtrigger/com.vitorgalvao.alfred.mangareader/continue/?argument=\(encodedPath)"

    guard let alfredURL = URL(string: alfredURLString) else {
      return showQuitDialog("Invalid path: \(urls[0].path)")
    }

    // Open in Alfred and quit app
    NSWorkspace.shared.open(alfredURL)
    NSApplication.shared.terminate(nil)
  }
}

func showQuitDialog(_ message: String) {
  let alert = NSAlert()
  alert.messageText = message
  alert.addButton(withTitle: "Quit")
  alert.runModal()
  NSApp.terminate(nil)
}
