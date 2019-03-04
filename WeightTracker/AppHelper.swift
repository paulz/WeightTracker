import Foundation

func loadAppData() {
    let processInfo = ProcessInfo.processInfo
    guard let appDataPath = processInfo.environment["LOAD_APPDATA"] else {
        return
    }
    let loaderUrl = URL(fileURLWithPath: #file)
    let bundleUrl = URL(fileURLWithPath: appDataPath, relativeTo: loaderUrl).appendingPathExtension("xcappdata")
    let contentsURL = bundleUrl.appendingPathComponent("AppData")
    let fileManager = FileManager.default
    let enumerator = fileManager.enumerator(at: contentsURL,
                                            includingPropertiesForKeys: [.isDirectoryKey],
                                            options: [],
                                            errorHandler: nil)!
    let destinationRoot = fileManager.urls(for: .libraryDirectory, in: .userDomainMask).last!.deletingLastPathComponent()
    let sourceRoot = contentsURL.standardizedFileURL.path
    while let sourceUrl = enumerator.nextObject() as? URL {
        guard let resourceValues = try? sourceUrl.resourceValues(forKeys: [.isDirectoryKey]),
            let isDirectory = resourceValues.isDirectory,
            !isDirectory else {
                continue
        }
        let path = sourceUrl.standardizedFileURL.path.replacingOccurrences(of: sourceRoot, with: "")
        let destinationURL = destinationRoot.appendingPathComponent(path)
        try? fileManager.removeItem(at: destinationURL)
        try! fileManager.createDirectory(at: destinationURL.deletingLastPathComponent(),
                                         withIntermediateDirectories: true,
                                         attributes: nil)
        try! fileManager.copyItem(at: sourceUrl,
                                  to: destinationURL)
    }
}
