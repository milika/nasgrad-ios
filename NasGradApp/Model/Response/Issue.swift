/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct Issue : Codable {
	let id : String?
	let ownerId : String?
	let title : String?
	let description : String?
	let issueType : String?
	let categories : [String]?
    let pictures: [String]?
	let picturePreview : String?
	let state : Int?
    let submittedCount : Int?
	let location : Location?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case ownerId = "ownerId"
		case title = "title"
		case description = "description"
		case issueType = "issueType"
		case categories = "categories"
        case pictures = "pictures"
		case picturePreview = "picturePreview"
		case state = "state"
        case submittedCount = "submittedCount"
		case location = "location"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		ownerId = try values.decodeIfPresent(String.self, forKey: .ownerId)
		title = try values.decodeIfPresent(String.self, forKey: .title)
		description = try values.decodeIfPresent(String.self, forKey: .description)
		issueType = try values.decodeIfPresent(String.self, forKey: .issueType)
		categories = try values.decodeIfPresent([String].self, forKey: .categories)
        pictures = try values.decodeIfPresent([String].self, forKey: .pictures)
		picturePreview = try values.decodeIfPresent(String.self, forKey: .picturePreview)
		state = try values.decodeIfPresent(Int.self, forKey: .state)
        submittedCount = try values.decodeIfPresent(Int.self, forKey: .submittedCount)
		location = try values.decodeIfPresent(Location.self, forKey: .location)
	}

}
