import SwiftUI
import UniformTypeIdentifiers

// CSV Document struct for file export
struct CSVDocument: FileDocument {
	static var readableContentTypes: [UTType] { [.commaSeparatedText] }

	var data: String

	init(data: String) {
		self.data = data
	}

	init(configuration: ReadConfiguration) throws {
		guard let data = configuration.file.regularFileContents,
			let string = String(data: data, encoding: .utf8)
		else {
			throw CocoaError(.fileReadCorruptFile)
		}
		self.data = string
	}

	func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
		let data = Data(data.utf8)
		return FileWrapper(regularFileWithContents: data)
	}
}
