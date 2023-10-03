// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
public enum L10n {
  public enum AccountStatus {
    /// iCloud Status: Available
    public static let available = L10n.tr("Localizable", "AccountStatus.Available", fallback: "iCloud Status: Available")
    /// iCloud Status: Could not determine
    public static let couldNotDetermine = L10n.tr("Localizable", "AccountStatus.CouldNotDetermine", fallback: "iCloud Status: Could not determine")
    /// iCloud Status: No account
    public static let noAccount = L10n.tr("Localizable", "AccountStatus.NoAccount", fallback: "iCloud Status: No account")
    /// iCloud Status: Restricted
    public static let restricted = L10n.tr("Localizable", "AccountStatus.Restricted", fallback: "iCloud Status: Restricted")
    /// iCloud Status: Unknown
    public static let unknown = L10n.tr("Localizable", "AccountStatus.Unknown", fallback: "iCloud Status: Unknown")
  }
  public enum Authorization {
    /// Authorization
    public static let authorization = L10n.tr("Localizable", "Authorization.Authorization", fallback: "Authorization")
    /// CodeSnippetsSync is sandboxed and does not have access to any directory other than its own container. Applications that do not authorize Xcode's UserData directory will not work.
    public static let detail = L10n.tr("Localizable", "Authorization.Detail", fallback: "CodeSnippetsSync is sandboxed and does not have access to any directory other than its own container. Applications that do not authorize Xcode's UserData directory will not work.")
    /// Authorization UserData Directory
    public static let title = L10n.tr("Localizable", "Authorization.Title", fallback: "Authorization UserData Directory")
  }
  public enum CodeSnippetInfo {
    /// Availability
    public static let availability = L10n.tr("Localizable", "CodeSnippetInfo.Availability", fallback: "Availability")
    /// Completion
    public static let completion = L10n.tr("Localizable", "CodeSnippetInfo.Completion", fallback: "Completion")
    /// Language
    public static let language = L10n.tr("Localizable", "CodeSnippetInfo.Language", fallback: "Language")
    /// Platform
    public static let platform = L10n.tr("Localizable", "CodeSnippetInfo.Platform", fallback: "Platform")
  }
  public enum Editor {
    /// Copy Snippet
    public static let copyCodeSnippet = L10n.tr("Localizable", "Editor.CopyCodeSnippet", fallback: "Copy Snippet")
  }
  public enum MainStatusItem {
    /// Force Sync
    public static let forceSync = L10n.tr("Localizable", "MainStatusItem.ForceSync", fallback: "Force Sync")
    /// Quit
    public static let quit = L10n.tr("Localizable", "MainStatusItem.Quit", fallback: "Quit")
    /// Show MainWindow
    public static let showMainWindow = L10n.tr("Localizable", "MainStatusItem.ShowMainWindow", fallback: "Show MainWindow")
  }
  public enum MainWindow {
    public enum Toolbar {
      /// Force Sync
      public static let forceSync = L10n.tr("Localizable", "MainWindow.Toolbar.ForceSync", fallback: "Force Sync")
      /// iCloud Status
      public static let iCloudStatus = L10n.tr("Localizable", "MainWindow.Toolbar.iCloudStatus", fallback: "iCloud Status")
      /// Show / Hide Sidebar
      public static let sidebar = L10n.tr("Localizable", "MainWindow.Toolbar.Sidebar", fallback: "Show / Hide Sidebar")
    }
  }
  public enum Sandbox {
    public enum OpenPanel {
      /// Please allow CodeSnippetsSync to access this directory
      public static let message = L10n.tr("Localizable", "Sandbox.OpenPanel.Message", fallback: "Please allow CodeSnippetsSync to access this directory")
      /// Allow
      public static let prompt = L10n.tr("Localizable", "Sandbox.OpenPanel.Prompt", fallback: "Allow")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
