import Foundation
import Combine

@MainActor
class AccountViewModel: ObservableObject {
    // Profile
    @Published var fullName: String = ""
    @Published var email: String = ""
    @Published var phone: String = ""
    @Published var companyName: String = ""
    @Published var companyWebsite: String = ""
    @Published var bio: String = ""
    @Published var avatarUrl: String? = nil
    
    // Address & Next.js Dynamic Locations
    @Published var country: String = "" {
        didSet { if oldValue != country && !country.isEmpty { Task { await fetchStates() } } }
    }
    @Published var region: String = "" {
        didSet { if oldValue != region && !region.isEmpty { Task { await fetchCities() } } }
    }
    @Published var city: String = ""
    @Published var postalCode: String = ""
    @Published var street: String = ""
    
    @Published var availableCountries: [String] = []
    @Published var availableRegions: [String] = []
    @Published var availableCities: [String] = []
    
    private var countryDTOs: [LocationItemDTO] = []
    private var stateDTOs: [LocationItemDTO] = []
    
    // Company
    @Published var isCorporateAdmin: Bool = false
    @Published var companyScope: String = ""
    @Published var companySpeciality: String = ""
    @Published var companyDescription: String = ""
    
    // Social
    @Published var socialLinks: [SocialLinkItem] = []
    
    // Loading States
    @Published var isLoading: Bool = false
    @Published var isSavingPersonal: Bool = false
    @Published var isSavingAddress: Bool = false
    @Published var isSavingCompany: Bool = false
    
    let platformOptions = ["Whatsapp", "LinkedIn", "Instagram", "Github", "Twitter", "Website", "Facebook", "YouTube"]
    let scopeOptions = ["All", "Technology", "Design", "Retail", "Finance"]
    let specialityOptions = ["All", "Software", "Hardware", "UI/UX", "Consulting"]
    
    private let repository: ProfileRepository
    
    init(repository: ProfileRepository) {
        self.repository = repository
    }
    
    func loadProfile() async {
        isLoading = true
        defer { isLoading = false }
        do {
            let data = try await repository.getProfile()
            
            await fetchCountries()
            
            self.fullName = data.fullName
            self.email = data.email
            self.phone = data.phone ?? ""
            self.companyName = data.companyName ?? ""
            self.companyWebsite = data.companyWebsite ?? ""
            self.bio = data.bio ?? ""
            self.avatarUrl = data.avatarUrl
            
            if let addr = data.address {
                self.country = addr.country ?? ""
                await fetchStates()
                
                self.region = addr.region ?? ""
                await fetchCities()
                
                self.city = addr.city ?? ""
                self.postalCode = addr.postalCode ?? ""
                self.street = addr.street ?? ""
            }
            
            self.companyScope = data.companyScope ?? ""
            self.companySpeciality = data.companySpeciality ?? ""
            self.companyDescription = data.companyDescription ?? ""
            
            self.socialLinks = data.socialLinks ?? []
            
            await fetchCountries()
        } catch {
            print(error)
        }
    }
    
    func fetchCountries() async {
        do {
            let countries = try await repository.getCountries()
            self.countryDTOs = countries
            self.availableCountries = countries.map { $0.name }
        } catch { print("Failed to fetch countries: \(error)") }
    }
    
    func fetchStates() async {
        guard let selectedCountry = countryDTOs.first(where: { $0.name == country }) else { return }
        do {
            let states = try await repository.getStates(countryCode: selectedCountry.isoCode)
            self.stateDTOs = states
            self.availableRegions = states.map { $0.name }
            self.city = ""
            self.availableCities = []
        } catch { print("Failed to fetch states: \(error)") }
    }
    
    func fetchCities() async {
        guard let selectedCountry = countryDTOs.first(where: { $0.name == country }),
              let selectedState = stateDTOs.first(where: { $0.name == region }) else { return }
        do {
            let cities = try await repository.getCities(countryCode: selectedCountry.isoCode, stateCode: selectedState.isoCode)
            self.availableCities = cities.map { $0.name }
        } catch { print("Failed to fetch cities: \(error)") }
    }
    
    func addSocialLink() { socialLinks.append(SocialLinkItem(platform: "", url: "")) }
    func removeSocialLink(id: String) { socialLinks.removeAll { $0.id == id } }
    
    func savePersonalProfile() async {
        isSavingPersonal = true
        defer { isSavingPersonal = false }
        do {
            let request = UpdatePersonalRequest(fullName: fullName, phone: phone, companyName: companyName, companyWebsite: companyWebsite, bio: bio)
            try await repository.updatePersonalProfile(request: request)
        } catch { print(error) }
    }
    
    func saveAddress() async {
        isSavingAddress = true
        defer { isSavingAddress = false }
        do {
            let request = UpdateAddressRequest(country: country, region: region, city: city, postalCode: postalCode, street: street)
            try await repository.updateAddress(request: request)
        } catch { print(error) }
    }
    
    func saveCorporateProfile() async {
        isSavingCompany = true
        defer { isSavingCompany = false }
        do {
            let request = UpdateCorporateRequest(scope: companyScope, speciality: companySpeciality, description: companyDescription)
            try await repository.updateCorporateProfile(request: request)
        } catch { print(error) }
    }
}
