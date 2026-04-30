import Foundation

struct ProfileBaseResponse: Codable {
    let success: Bool
    let data: ProfileResponse
}

struct ProfileResponse: Codable {
    let id: String
    let fullName: String
    let email: String
    let phone: String?
    let companyName: String?
    let companyWebsite: String?
    let bio: String?
    let avatarUrl: String?
    
    let companyScope: String?
    let companySpeciality: String?
    let companyDescription: String?
    
    let address: AddressDTO?
    let socialLinks: [SocialLinkItem]?
}

struct AddressDTO: Codable {
    let country: String?
    let region: String?
    let city: String?
    let postalCode: String?
    let street: String?
}

struct LocationItemDTO: Codable, Hashable {
    let name: String
    let isoCode: String
}

struct UpdatePersonalRequest: Codable {
    let fullName: String
    let phone: String
    let companyName: String
    let companyWebsite: String
    let bio: String
}

struct UpdateAddressRequest: Codable {
    let country: String
    let region: String
    let city: String
    let postalCode: String
    let street: String
}

struct UpdateCorporateRequest: Codable {
    let scope: String
    let speciality: String
    let description: String
}

struct SocialLinkItem: Codable, Identifiable {
    var id: String
    var platform: String
    var url: String
    
    init(id: String = UUID().uuidString, platform: String, url: String) {
        self.id = id
        self.platform = platform
        self.url = url
    }
    
    enum CodingKeys: String, CodingKey {
        case id, platform, url
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(String.self, forKey: .id) ?? UUID().uuidString
        self.platform = try container.decode(String.self, forKey: .platform)
        self.url = try container.decode(String.self, forKey: .url)
    }
}
