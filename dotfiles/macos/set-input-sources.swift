// Enables a fixed, ordered set of keyboard layouts and selects the first one.
//
// Why this exists instead of a plain `defaults write com.apple.HIToolbox`:
// the plist entries are keyed by a NUMERIC "KeyboardLayout ID" (Swiss German is
// 19, ABC is some other Apple resource id), and there is no supported way to look
// those numbers up -- they are not exposed as a TIS property and Apple's layout
// bundle stores keymaps, not an id table. Hardcoding them means shipping a magic
// number that cannot be verified. Calling TISEnableInputSource instead makes
// macOS resolve every id itself and write the plist for us.
//
// Argument: the input source IDs to enable, in order, most-preferred first.
// Stdout: the display name of each layout, one per line, in that same order.
// Those names are what the HIToolbox preference domain keys its entries by
// ("KeyboardLayout Name"), so printing them here is what lets the caller order
// the login-window list without hardcoding a single one of them.
// Keyboard layouts that are enabled but NOT listed get disabled; non-keyboard
// input methods (Emoji viewer, IMEs) are left completely alone.
//
// Exit codes: 0 = state now matches, 2 = a requested layout is not installed yet
// (a freshly installed .keylayout needs a logout/reboot before TIS can see it).

import Foundation
import Carbon

let wanted = Array(CommandLine.arguments.dropFirst())
guard !wanted.isEmpty else {
    FileHandle.standardError.write("usage: set-input-sources <input-source-id> ...\n".data(using: .utf8)!)
    exit(64)
}

func sourceID(_ src: TISInputSource) -> String? {
    guard let p = TISGetInputSourceProperty(src, kTISPropertyInputSourceID) else { return nil }
    return (Unmanaged<CFString>.fromOpaque(p).takeUnretainedValue() as String)
}

func isKeyboardLayout(_ src: TISInputSource) -> Bool {
    guard let p = TISGetInputSourceProperty(src, kTISPropertyInputSourceType) else { return false }
    let t = Unmanaged<CFString>.fromOpaque(p).takeUnretainedValue() as String
    return t == (kTISTypeKeyboardLayout as String)
}

func isEnabled(_ src: TISInputSource) -> Bool {
    guard let p = TISGetInputSourceProperty(src, kTISPropertyInputSourceIsEnabled) else { return false }
    return CFBooleanGetValue(Unmanaged<CFBoolean>.fromOpaque(p).takeUnretainedValue())
}

// includeAllInstalled: true -> also returns sources that are installed but disabled.
guard let all = TISCreateInputSourceList(nil, true)?.takeRetainedValue() as? [TISInputSource] else {
    FileHandle.standardError.write("TISCreateInputSourceList failed\n".data(using: .utf8)!)
    exit(1)
}

let dryRun = ProcessInfo.processInfo.environment["DRY_RUN"] == "1"
var byID: [String: TISInputSource] = [:]
for s in all { if let i = sourceID(s) { byID[i] = s } }

var missing: [String] = []
for id in wanted where byID[id] == nil { missing.append(id) }

// Enable every wanted layout. NOTE: macOS does not preserve the order they are
// enabled in -- the preference domain gets its own ordering -- so the caller
// re-imposes the fallback order using the names printed below.
var resolvedNames: [String] = []
for id in wanted {
    guard let src = byID[id] else { continue }
    if dryRun { print("would enable  \(id) (currently \(isEnabled(src) ? "enabled" : "disabled"))"); continue }
    let err = TISEnableInputSource(src)
    if err != noErr { FileHandle.standardError.write("enable \(id) failed: \(err)\n".data(using: .utf8)!) }
    if let p = TISGetInputSourceProperty(src, kTISPropertyLocalizedName) {
        resolvedNames.append(Unmanaged<CFString>.fromOpaque(p).takeUnretainedValue() as String)
    }
}

// Disable any other *keyboard layout* that is currently on.
for s in all {
    guard let id = sourceID(s), isKeyboardLayout(s), isEnabled(s), !wanted.contains(id) else { continue }
    if dryRun { print("would disable \(id)"); continue }
    let err = TISDisableInputSource(s)
    if err != noErr { FileHandle.standardError.write("disable \(id) failed: \(err)\n".data(using: .utf8)!) }
}

if let first = wanted.first, let src = byID[first] {
    if dryRun { print("would select  \(first)") } else { TISSelectInputSource(src) }
}

if !dryRun { for n in resolvedNames { print(n) } }

if !missing.isEmpty {
    FileHandle.standardError.write("not installed yet: \(missing.joined(separator: ", "))\n".data(using: .utf8)!)
    exit(2)
}
exit(0)
