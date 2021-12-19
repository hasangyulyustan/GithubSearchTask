import Foundation

struct UploadData {
    var tag: Int = 0
    var data: Data
    var fileName: String
    var mimeType: String
    var name: String

    var sizeInBytes: Int {
        return data.count
    }
}
