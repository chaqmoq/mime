import Foundation

extension MIME {
    /// Guesses a `MIME` type from data.
    ///
    /// - Parameter data: A value with `Data` type.
    /// - Returns: A guessed `MIME` or `.init("application/octet-stream")` if it can't guess.
    public static func guess(from data: Data) -> MIME {
        guess(from: [UInt8](data))
    }

    /// Guesses a `MIME` type from bytes.
    ///
    /// - Parameter bytes: A value in bytes.
    /// - Returns: A guessed `MIME` type or `.init("application/octet-stream")` if it can't guess.
    public static func guess(from bytes: [UInt8]) -> MIME {
        let bytesCount = bytes.count

        if bytesCount > 57 && bytes[0...3] == [0x50, 0x4B, 0x03, 0x04] && bytes[30...57] == [
            0x6D, 0x69, 0x6D, 0x65, 0x74, 0x79, 0x70, 0x65, 0x61, 0x70,
            0x70, 0x6C, 0x69, 0x63, 0x61, 0x74, 0x69, 0x6F, 0x6E, 0x2F,
            0x65, 0x70, 0x75, 0x62, 0x2B, 0x7A, 0x69, 0x70] {
            return .init("application/epub+zip")
        } else if bytesCount > 4 &&
            (bytes[0...4] == [0x4F, 0x54, 0x54, 0x4F, 0x00] || bytes[0...4] == [0x00, 0x01, 0x00, 0x00, 0x00]) {
            return .init("application/font-sfnt")
        } else if bytesCount > 7 &&
            bytes[0...3] == [0x77, 0x4F, 0x46, 0x46] &&
            (bytes[4...7] == [0x00, 0x01, 0x00, 0x00] || bytes[4...7] == [0x4F, 0x54, 0x54, 0x4F]) {
            return .init("application/font-woff")
        } else if bytesCount > 7 &&
            bytes[0...3] == [0x77, 0x4F, 0x46, 0x32] &&
            (bytes[4...7] == [0x00, 0x01, 0x00, 0x00] || bytes[4...7] == [0x4F, 0x54, 0x54, 0x4F]) {
            return .init("application/font-woff", ext: "woff2")
        } else if bytesCount > 2 && bytes[0...2] == [0x1F, 0x8B, 0x08] {
            return .init("application/gzip")
        } else if bytesCount > 3 && bytes[0...3] == [0x25, 0x50, 0x44, 0x46] {
            return .init("application/pdf")
        } else if bytesCount > 1 && bytes[0...1] == [0x25, 0x21] {
            return .init("application/postscript")
        } else if bytesCount > 4 && bytes[0...4] == [0x7B, 0x5C, 0x72, 0x74, 0x66] {
            return .init("application/rtf")
        } else if bytesCount > 3 &&
            (bytes[0...3] == [0x4D, 0x53, 0x43, 0x46] || bytes[0...3] == [0x49, 0x53, 0x63, 0x28]) {
            return .init("application/vnd.ms-cab-compressed")
        } else if bytesCount > 5 && bytes[0...5] == [0x37, 0x7A, 0xBC, 0xAF, 0x27, 0x1C] {
            return .init("application/x-7z-compressed")
        } else if bytesCount > 2 && bytes[0...2] == [0x42, 0x5A, 0x68] {
            return .init("application/x-bzip2")
        } else if bytesCount > 1 && (bytes[0...1] == [0x1F, 0xA0] || bytes[0...1] == [0x1F, 0x9D]) {
            return .init("application/x-compress")
        } else if bytesCount > 20 && bytes[0...20] == [
            0x21, 0x3C, 0x61, 0x72, 0x63, 0x68, 0x3E, 0x0A, 0x64, 0x65, 0x62,
            0x69, 0x61, 0x6E, 0x2D, 0x62, 0x69, 0x6E, 0x61, 0x72, 0x79] {
            return .init("application/x-deb")
        } else if bytesCount > 3 && bytes[0...3] == [0x43, 0x72, 0x32, 0x34] {
            return .init("application/x-chrome-extension")
        } else if bytesCount > 3 && bytes[0...3] == [0x4C, 0x5A, 0x49, 0x50] {
            return .init("application/x-lzip")
        } else if bytesCount > 1 && bytes[0...1] == [0x4D, 0x5A] {
            return .init("application/x-msdownload")
        } else if bytesCount > 7 && bytes[0...7] == [0xD0, 0xCF, 0x11, 0xE0, 0xA1, 0xB1, 0x1A, 0xE1] {
            return .init("application/x-msi")
        } else if bytesCount > 13 &&
            bytes[0...13] == [0x06, 0x0E, 0x2B, 0x34, 0x02, 0x05, 0x01, 0x01, 0x0D, 0x01, 0x02, 0x01, 0x01, 0x02] {
            return .init("application/mxf")
        } else if bytesCount > 3 && bytes[0...3] == [0x4E, 0x45, 0x53, 0x1A] {
            return .init("application/x-nes-rom")
        } else if bytesCount > 2 && (bytes[0] == 0x43 || bytes[0] == 0x46) && bytes[1...2] == [0x57, 0x53] {
            return .init("application/x-shockwave-flash")
        } else if bytesCount > 3 && bytes[0...3] == [0x53, 0x51, 0x4C, 0x69] {
            return .init("application/x-sqlite3")
        } else if bytesCount > 261 && bytes[257...261] == [0x75, 0x73, 0x74, 0x61, 0x72] {
            return .init("application/x-tar")
        } else if bytesCount > 6 &&
            bytes[0...5] == [0x52, 0x61, 0x72, 0x21, 0x1A, 0x07] &&
            (bytes[6] == 0x0 || bytes[6] == 0x1) {
            return .init("application/x-rar-compressed")
        } else if bytesCount > 3 && bytes[0...3] == [0xED, 0xAB, 0xEE, 0xDB] {
            return .init("application/x-rpm")
        } else if bytesCount > 6 && bytes[0...6] == [0x21, 0x3C, 0x61, 0x72, 0x63, 0x68, 0x3E] {
            return .init("application/x-archive")
        } else if bytesCount > 49 && bytes[0...3] == [0x50, 0x4B, 0x03, 0x04] && bytes[30...49] == [
            0x4D, 0x45, 0x54, 0x41, 0x2D, 0x49, 0x4E, 0x46, 0x2F, 0x6D,
            0x6F, 0x7A, 0x69, 0x6C, 0x6C, 0x61, 0x2E, 0x72, 0x73, 0x61] {
            return .init("application/x-xpinstall")
        } else if bytesCount > 5 && bytes[0...5] == [0xFD, 0x37, 0x7A, 0x58, 0x5A, 0x00] {
            return .init("application/x-xz")
        } else if bytesCount > 3 &&
            bytes[0...1] == [0x50, 0x4B] &&
            (bytes[2] == 0x3 || bytes[2] == 0x5 || bytes[2] == 0x7) &&
            (bytes[3] == 0x4 || bytes[3] == 0x6 || bytes[3] == 0x8) {
            return .init("application/zip")
        } else if bytesCount > 5 && bytes[0...5] == [0x23, 0x21, 0x41, 0x4D, 0x52, 0x0A] {
            return .init("audio/amr")
        } else if (bytesCount > 3 && bytes[0...3] == [0x4D, 0x34, 0x41, 0x20]) ||
            (bytesCount > 10 && bytes[4...10] == [0x66, 0x74, 0x79, 0x70, 0x4D, 0x34, 0x41]) {
            return .init("audio/m4a")
        } else if bytesCount > 3 && bytes[0...3] == [0x4D, 0x54, 0x68, 0x64] {
            return .init("audio/midi")
        } else if (bytesCount > 2 && bytes[0...2] == [0x49, 0x44, 0x33]) ||
            (bytesCount > 1 && bytes[0...1] == [0xFF, 0xFB]) {
            return .init("audio/mpeg")
        } else if bytesCount > 35 && bytes[28...35] == [0x4F, 0x70, 0x75, 0x73, 0x48, 0x65, 0x61, 0x64] {
            return .init("audio/opus")
        } else if bytesCount > 3 && bytes[0...3] == [0x4F, 0x67, 0x67, 0x53] {
            return .init("audio/ogg")
        } else if bytesCount > 3 && bytes[0...3] == [0x66, 0x4C, 0x61, 0x43] {
            return .init("audio/x-flac")
        } else if bytesCount > 11 &&
            bytes[0...3] == [0x52, 0x49, 0x46, 0x46] &&
            bytes[8...11] == [0x57, 0x41, 0x56, 0x45] {
            return .init("audio/x-wav")
        } else if bytesCount > 1 && bytes[0...1] == [0x42, 0x4D] {
            return .init("image/bmp")
        } else if bytesCount > 3 && bytes[0...3] == [0x46, 0x4C, 0x49, 0x46] {
            return .init("image/flif")
        } else if bytesCount > 2 && bytes[0...2] == [0x47, 0x49, 0x46] {
            return .init("image/gif")
        } else if bytesCount > 2 && bytes[0...2] == [0xFF, 0xD8, 0xFF] {
            return .init("image/jpeg")
        } else if bytesCount > 3 && bytes[0...3] == [0x89, 0x50, 0x4E, 0x47] {
            return .init("image/png")
        } else if bytesCount > 3 &&
            (bytes[0...3] == [0x49, 0x49, 0x2A, 0x00] || bytes[0...3] == [0x4D, 0x4D, 0x00, 0x2A]) {
            return bytesCount > 9 && bytes[8...9] == [0x43, 0x52] ? .init("image/x-canon-cr2") : .init("image/tiff")
        } else if bytesCount > 3 && bytes[0...3] == [0x38, 0x42, 0x50, 0x53] {
            return .init("image/vnd.adobe.photoshop")
        } else if bytesCount > 2 && bytes[0...2] == [0x49, 0x49, 0xBC] {
            return .init("image/vnd.ms-photo")
        } else if bytesCount > 11 && bytes[8...11] == [0x57, 0x45, 0x42, 0x50] {
            return .init("image/webp")
        } else if bytesCount > 3 && bytes[0...3] == [0x00, 0x00, 0x01, 0x00] {
            return .init("image/x-icon")
        } else if
            (
                bytesCount > 7 &&
                bytes[0...2] == [0x00, 0x00, 0x00] &&
                (bytes[3] == 0x18 || bytes[3] == 0x20) &&
                bytes[4...7] == [0x66, 0x74, 0x79, 0x70]
            ) ||
            (
                bytesCount > 3 && bytes[0...3] == [0x33, 0x67, 0x70, 0x35]
            ) ||
            (
                bytesCount > 27 &&
                bytes[0...11] == [0x00, 0x00, 0x00, 0x1C, 0x66, 0x74, 0x79, 0x70, 0x6D, 0x70, 0x34, 0x32] &&
                bytes[16...27] == [0x6D, 0x70, 0x34, 0x31, 0x6D, 0x70, 0x34, 0x32, 0x69, 0x73, 0x6F, 0x6D]
            ) ||
            (
                bytesCount > 11 &&
                bytes[0...11] == [0x00, 0x00, 0x00, 0x1C, 0x66, 0x74, 0x79, 0x70, 0x69, 0x73, 0x6F, 0x6D]
            ) ||
            (
                bytesCount > 15 &&
                bytes[0...15] == [
                    0x00, 0x00, 0x00, 0x1C, 0x66, 0x74, 0x79, 0x70, 0x6D, 0x70, 0x34, 0x32, 0x00, 0x00, 0x00, 0x00
                ]
            ) {
            return .init("video/mp4")
        } else if bytesCount > 3 &&
            bytes[0...2] == [0x00, 0x00, 0x01] &&
            String(format: "%2X", bytes[3]).first == "B" {
            return .init("video/mpeg")
        } else if bytesCount > 7 && bytes[0...7] == [0x00, 0x00, 0x00, 0x14, 0x66, 0x74, 0x79, 0x70] {
            return .init("video/quicktime")
        } else if bytesCount > 3 && bytes[0...3] == [0x46, 0x4C, 0x56, 0x01] {
            return .init("video/x-flv")
        } else if bytesCount > 10 &&
            bytes[0...10] == [0x00, 0x00, 0x00, 0x1C, 0x66, 0x74, 0x79, 0x70, 0x4D, 0x34, 0x56] {
            return .init("video/x-m4v")
        } else if bytesCount > 9 && bytes[0...9] == [0x30, 0x26, 0xB2, 0x75, 0x8E, 0x66, 0xCF, 0x11, 0xA6, 0xD9] {
            return .init("video/x-ms-wmv")
        } else if bytesCount > 10 &&
            bytes[0...3] == [0x52, 0x49, 0x46, 0x46] &&
            bytes[8...10] == [0x41, 0x56, 0x49] {
            return .init("video/x-msvideo")
        }

        return .init()
    }
}
