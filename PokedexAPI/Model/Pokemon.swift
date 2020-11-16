// MARK: - Pokemon
public struct Pokemon: Codable {
    public let abilities: [Ability]
    public let baseExperience: Int
    public let forms: [Species]
    public let gameIndices: [GameIndex]
    public let height: Int
    public let heldItems: [HeldItem]
    public let id: Int
    public let isDefault: Bool
    public let locationAreaEncounters: String
    public let moves: [Move]
    public let name: String
    public let order: Int
    public let species: Species
    public let sprites: Sprites
    public let stats: [Stat]
    public let types: [TypeElement]
    public let weight: Int
    public var breed: Breed?
    public var image: UIImage?
    public var description: String? {
        guard let pokemonName = name.split(separator: "-").first else { return nil }
        return breed?.flavorTextEntries.first(where: {$0.flavorText.contains(pokemonName.prefix(1).uppercased() + pokemonName.lowercased().dropFirst()) && $0.language.name == "en"}).map({ $0.flavorText.replacingOccurrences(of: ".\n", with: ". ").filter({ !"\n".contains($0) }) })
    }

    enum CodingKeys: String, CodingKey {
        case abilities
        case baseExperience = "base_experience"
        case forms
        case gameIndices = "game_indices"
        case height
        case heldItems = "held_items"
        case id
        case isDefault = "is_default"
        case locationAreaEncounters = "location_area_encounters"
        case moves, name, order, species, sprites, stats, types, weight
    }

    public init(abilities: [Ability], baseExperience: Int, forms: [Species], gameIndices: [GameIndex], height: Int, heldItems: [HeldItem], id: Int, isDefault: Bool, locationAreaEncounters: String, moves: [Move], name: String, order: Int, species: Species, sprites: Sprites, stats: [Stat], types: [TypeElement], weight: Int, breed: Breed?, image: UIImage?) {
        self.abilities = abilities
        self.baseExperience = baseExperience
        self.forms = forms
        self.gameIndices = gameIndices
        self.height = height
        self.heldItems = heldItems
        self.id = id
        self.isDefault = isDefault
        self.locationAreaEncounters = locationAreaEncounters
        self.moves = moves
        self.name = name
        self.order = order
        self.species = species
        self.sprites = sprites
        self.stats = stats
        self.types = types
        self.weight = weight
        self.breed = breed
        self.image = image
    }
}

// MARK: - Ability
public struct Ability: Codable {
    public let ability: Species
    public let isHidden: Bool
    public let slot: Int

    enum CodingKeys: String, CodingKey {
        case ability
        case isHidden = "is_hidden"
        case slot
    }

    public init(ability: Species, isHidden: Bool, slot: Int) {
        self.ability = ability
        self.isHidden = isHidden
        self.slot = slot
    }
}

// MARK: - Species
public struct Species: Codable {
    public let name: String
    public let url: String

    public init(name: String, url: String) {
        self.name = name
        self.url = url
    }
}

// MARK: - Breed
public struct Breed: Codable {
    public let baseHappiness, captureRate: Int
    public let color: Color
    public let eggGroups: [Color]
    public let evolutionChain: EvolutionChain
    public let evolvesFromSpecies: Color?
    public let flavorTextEntries: [FlavorTextEntry]
    public let formDescriptions: [String]?
    public let formsSwitchable: Bool
    public let genderRate: Int
    public let genera: [Genus]
    public let generation, growthRate, habitat: Color
    public let hasGenderDifferences: Bool
    public let hatchCounter, id: Int
    public let isBaby, isLegendary, isMythical: Bool
    public let name: String
    public let names: [Name]
    public let order: Int
    public let palParkEncounters: [PalParkEncounter]
    public let pokedexNumbers: [PokedexNumber]
    public let shape: Color
    public let varieties: [Variety]

    enum CodingKeys: String, CodingKey {
        case baseHappiness = "base_happiness"
        case captureRate = "capture_rate"
        case color
        case eggGroups = "egg_groups"
        case evolutionChain = "evolution_chain"
        case evolvesFromSpecies = "evolves_from_species"
        case flavorTextEntries = "flavor_text_entries"
        case formDescriptions = "form_descriptions"
        case formsSwitchable = "forms_switchable"
        case genderRate = "gender_rate"
        case genera, generation
        case growthRate = "growth_rate"
        case habitat
        case hasGenderDifferences = "has_gender_differences"
        case hatchCounter = "hatch_counter"
        case id
        case isBaby = "is_baby"
        case isLegendary = "is_legendary"
        case isMythical = "is_mythical"
        case name, names, order
        case palParkEncounters = "pal_park_encounters"
        case pokedexNumbers = "pokedex_numbers"
        case shape, varieties
    }

    public init(baseHappiness: Int, captureRate: Int, color: Color, eggGroups: [Color], evolutionChain: EvolutionChain, evolvesFromSpecies: Color?, flavorTextEntries: [FlavorTextEntry], formDescriptions: [String]?, formsSwitchable: Bool, genderRate: Int, genera: [Genus], generation: Color, growthRate: Color, habitat: Color, hasGenderDifferences: Bool, hatchCounter: Int, id: Int, isBaby: Bool, isLegendary: Bool, isMythical: Bool, name: String, names: [Name], order: Int, palParkEncounters: [PalParkEncounter], pokedexNumbers: [PokedexNumber], shape: Color, varieties: [Variety]) {
        self.baseHappiness = baseHappiness
        self.captureRate = captureRate
        self.color = color
        self.eggGroups = eggGroups
        self.evolutionChain = evolutionChain
        self.evolvesFromSpecies = evolvesFromSpecies
        self.flavorTextEntries = flavorTextEntries
        self.formDescriptions = formDescriptions
        self.formsSwitchable = formsSwitchable
        self.genderRate = genderRate
        self.genera = genera
        self.generation = generation
        self.growthRate = growthRate
        self.habitat = habitat
        self.hasGenderDifferences = hasGenderDifferences
        self.hatchCounter = hatchCounter
        self.id = id
        self.isBaby = isBaby
        self.isLegendary = isLegendary
        self.isMythical = isMythical
        self.name = name
        self.names = names
        self.order = order
        self.palParkEncounters = palParkEncounters
        self.pokedexNumbers = pokedexNumbers
        self.shape = shape
        self.varieties = varieties
    }
}

// MARK: - Color
public struct Color: Codable {
    public let name: String
    public let url: String

    public init(name: String, url: String) {
        self.name = name
        self.url = url
    }
}

// MARK: - EvolutionChain
public struct EvolutionChain: Codable {
    public let url: String

    public init(url: String) {
        self.url = url
    }
}

// MARK: - FlavorTextEntry
public struct FlavorTextEntry: Codable {
    public let flavorText: String
    public let language, version: Color

    enum CodingKeys: String, CodingKey {
        case flavorText = "flavor_text"
        case language, version
    }

    public init(flavorText: String, language: Color, version: Color) {
        self.flavorText = flavorText
        self.language = language
        self.version = version
    }
}

// MARK: - Genus
public struct Genus: Codable {
    public let genus: String
    public let language: Color

    public init(genus: String, language: Color) {
        self.genus = genus
        self.language = language
    }
}

// MARK: - Name
public struct Name: Codable {
    public let language: Color
    public let name: String

    public init(language: Color, name: String) {
        self.language = language
        self.name = name
    }
}

// MARK: - PalParkEncounter
public struct PalParkEncounter: Codable {
    public let area: Color
    public let baseScore, rate: Int

    enum CodingKeys: String, CodingKey {
        case area
        case baseScore = "base_score"
        case rate
    }

    public init(area: Color, baseScore: Int, rate: Int) {
        self.area = area
        self.baseScore = baseScore
        self.rate = rate
    }
}

// MARK: - PokedexNumber
public struct PokedexNumber: Codable {
    public let entryNumber: Int
    public let pokedex: Color

    enum CodingKeys: String, CodingKey {
        case entryNumber = "entry_number"
        case pokedex
    }

    public init(entryNumber: Int, pokedex: Color) {
        self.entryNumber = entryNumber
        self.pokedex = pokedex
    }
}

// MARK: - Variety
public struct Variety: Codable {
    public let isDefault: Bool
    public let pokemon: Color

    enum CodingKeys: String, CodingKey {
        case isDefault = "is_default"
        case pokemon
    }

    public init(isDefault: Bool, pokemon: Color) {
        self.isDefault = isDefault
        self.pokemon = pokemon
    }
}

// MARK: - GameIndex
public struct GameIndex: Codable {
    public let gameIndex: Int
    public let version: Species

    enum CodingKeys: String, CodingKey {
        case gameIndex = "game_index"
        case version
    }

    public init(gameIndex: Int, version: Species) {
        self.gameIndex = gameIndex
        self.version = version
    }
}

// MARK: - HeldItem
public struct HeldItem: Codable {
    public let item: Species
    public let versionDetails: [VersionDetail]

    enum CodingKeys: String, CodingKey {
        case item
        case versionDetails = "version_details"
    }

    public init(item: Species, versionDetails: [VersionDetail]) {
        self.item = item
        self.versionDetails = versionDetails
    }
}

// MARK: - VersionDetail
public struct VersionDetail: Codable {
    public let rarity: Int
    public let version: Species

    public init(rarity: Int, version: Species) {
        self.rarity = rarity
        self.version = version
    }
}

// MARK: - Move
public struct Move: Codable {
    public let move: Species
    public let versionGroupDetails: [VersionGroupDetail]

    enum CodingKeys: String, CodingKey {
        case move
        case versionGroupDetails = "version_group_details"
    }

    public init(move: Species, versionGroupDetails: [VersionGroupDetail]) {
        self.move = move
        self.versionGroupDetails = versionGroupDetails
    }
}

// MARK: - VersionGroupDetail
public struct VersionGroupDetail: Codable {
    public let levelLearnedAt: Int
    public let moveLearnMethod, versionGroup: Species

    enum CodingKeys: String, CodingKey {
        case levelLearnedAt = "level_learned_at"
        case moveLearnMethod = "move_learn_method"
        case versionGroup = "version_group"
    }

    public init(levelLearnedAt: Int, moveLearnMethod: Species, versionGroup: Species) {
        self.levelLearnedAt = levelLearnedAt
        self.moveLearnMethod = moveLearnMethod
        self.versionGroup = versionGroup
    }
}

// MARK: - GenerationV
public struct GenerationV: Codable {
    public let blackWhite: Sprites

    enum CodingKeys: String, CodingKey {
        case blackWhite = "black-white"
    }

    public init(blackWhite: Sprites) {
        self.blackWhite = blackWhite
    }
}

// MARK: - GenerationIv
public struct GenerationIv: Codable {
    public let diamondPearl, heartgoldSoulsilver, platinum: Sprites

    enum CodingKeys: String, CodingKey {
        case diamondPearl = "diamond-pearl"
        case heartgoldSoulsilver = "heartgold-soulsilver"
        case platinum
    }

    public init(diamondPearl: Sprites, heartgoldSoulsilver: Sprites, platinum: Sprites) {
        self.diamondPearl = diamondPearl
        self.heartgoldSoulsilver = heartgoldSoulsilver
        self.platinum = platinum
    }
}

// MARK: - Versions
public struct Versions: Codable {
    public let generationI: GenerationI
    public let generationIi: GenerationIi
    public let generationIii: GenerationIii
    public let generationIv: GenerationIv
    public let generationV: GenerationV
    public let generationVi: GenerationVi
    public let generationVii: GenerationVii
    public let generationViii: GenerationViii

    enum CodingKeys: String, CodingKey {
        case generationI = "generation-i"
        case generationIi = "generation-ii"
        case generationIii = "generation-iii"
        case generationIv = "generation-iv"
        case generationV = "generation-v"
        case generationVi = "generation-vi"
        case generationVii = "generation-vii"
        case generationViii = "generation-viii"
    }

    public init(generationI: GenerationI, generationIi: GenerationIi, generationIii: GenerationIii, generationIv: GenerationIv, generationV: GenerationV, generationVi: GenerationVi, generationVii: GenerationVii, generationViii: GenerationViii) {
        self.generationI = generationI
        self.generationIi = generationIi
        self.generationIii = generationIii
        self.generationIv = generationIv
        self.generationV = generationV
        self.generationVi = generationVi
        self.generationVii = generationVii
        self.generationViii = generationViii
    }
}

// MARK: - Sprites
public class Sprites: Codable {
    public let backDefault: String?
    public let backFemale: String?
    public let backShiny: String?
    public let backShinyFemale: String?
    public let frontDefault: String?
    public let frontFemale: String?
    public let frontShiny: String?
    public let frontShinyFemale: String?
    public let other: Other?
    public let versions: Versions?
    public let animated: Sprites?

    enum CodingKeys: String, CodingKey {
        case backDefault = "back_default"
        case backFemale = "back_female"
        case backShiny = "back_shiny"
        case backShinyFemale = "back_shiny_female"
        case frontDefault = "front_default"
        case frontFemale = "front_female"
        case frontShiny = "front_shiny"
        case frontShinyFemale = "front_shiny_female"
        case other, versions, animated
    }

    public init(backDefault: String, backFemale: String?, backShiny: String, backShinyFemale: String?, frontDefault: String, frontFemale: String?, frontShiny: String, frontShinyFemale: String?, other: Other?, versions: Versions?, animated: Sprites?) {
        self.backDefault = backDefault
        self.backFemale = backFemale
        self.backShiny = backShiny
        self.backShinyFemale = backShinyFemale
        self.frontDefault = frontDefault
        self.frontFemale = frontFemale
        self.frontShiny = frontShiny
        self.frontShinyFemale = frontShinyFemale
        self.other = other
        self.versions = versions
        self.animated = animated
    }
}

// MARK: - GenerationI
public struct GenerationI: Codable {
    public let redBlue, yellow: RedBlue

    enum CodingKeys: String, CodingKey {
        case redBlue = "red-blue"
        case yellow
    }

    public init(redBlue: RedBlue, yellow: RedBlue) {
        self.redBlue = redBlue
        self.yellow = yellow
    }
}

// MARK: - RedBlue
public struct RedBlue: Codable {
    public let backDefault: String?
    public let backGray: String?
    public let frontDefault: String?
    public let frontGray: String?

    enum CodingKeys: String, CodingKey {
        case backDefault = "back_default"
        case backGray = "back_gray"
        case frontDefault = "front_default"
        case frontGray = "front_gray"
    }

    public init(backDefault: String, backGray: String, frontDefault: String, frontGray: String) {
        self.backDefault = backDefault
        self.backGray = backGray
        self.frontDefault = frontDefault
        self.frontGray = frontGray
    }
}

// MARK: - GenerationIi
public struct GenerationIi: Codable {
    public let crystal, gold, silver: Crystal

    public init(crystal: Crystal, gold: Crystal, silver: Crystal) {
        self.crystal = crystal
        self.gold = gold
        self.silver = silver
    }
}

// MARK: - Crystal
public struct Crystal: Codable {
    public let backDefault: String?
    public let backShiny: String?
    public let frontDefault: String?
    public let frontShiny: String?

    enum CodingKeys: String, CodingKey {
        case backDefault = "back_default"
        case backShiny = "back_shiny"
        case frontDefault = "front_default"
        case frontShiny = "front_shiny"
    }

    public init(backDefault: String, backShiny: String, frontDefault: String, frontShiny: String) {
        self.backDefault = backDefault
        self.backShiny = backShiny
        self.frontDefault = frontDefault
        self.frontShiny = frontShiny
    }
}

// MARK: - GenerationIii
public struct GenerationIii: Codable {
    public let emerald: Emerald
    public let fireredLeafgreen, rubySapphire: Crystal

    enum CodingKeys: String, CodingKey {
        case emerald
        case fireredLeafgreen = "firered-leafgreen"
        case rubySapphire = "ruby-sapphire"
    }

    public init(emerald: Emerald, fireredLeafgreen: Crystal, rubySapphire: Crystal) {
        self.emerald = emerald
        self.fireredLeafgreen = fireredLeafgreen
        self.rubySapphire = rubySapphire
    }
}

// MARK: - Emerald
public struct Emerald: Codable {
    public let frontDefault: String?
    public let frontShiny: String?

    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
        case frontShiny = "front_shiny"
    }

    public init(frontDefault: String, frontShiny: String) {
        self.frontDefault = frontDefault
        self.frontShiny = frontShiny
    }
}

// MARK: - GenerationVi
public struct GenerationVi: Codable {
    public let omegarubyAlphasapphire: Sprites
    public let xY: Sprites

    enum CodingKeys: String, CodingKey {
        case omegarubyAlphasapphire = "omegaruby-alphasapphire"
        case xY = "x-y"
    }

    public init(omegarubyAlphasapphire: Sprites, xY: Sprites) {
        self.omegarubyAlphasapphire = omegarubyAlphasapphire
        self.xY = xY
    }
}

// MARK: - GenerationVii
public struct GenerationVii: Codable {
    public let icons: Sprites
    public let ultraSunUltraMoon: Sprites

    enum CodingKeys: String, CodingKey {
        case icons
        case ultraSunUltraMoon = "ultra-sun-ultra-moon"
    }

    public init(icons: Sprites, ultraSunUltraMoon: Sprites) {
        self.icons = icons
        self.ultraSunUltraMoon = ultraSunUltraMoon
    }
}

// MARK: - GenerationViii
public struct GenerationViii: Codable {
    public let icons: Sprites

    public init(icons: Sprites) {
        self.icons = icons
    }
}

// MARK: - Other
public struct Other: Codable {
    public let dreamWorld: Sprites
    public let officialArtwork: OfficialArtwork

    enum CodingKeys: String, CodingKey {
        case dreamWorld = "dream_world"
        case officialArtwork = "official-artwork"
    }

    public init(dreamWorld: Sprites, officialArtwork: OfficialArtwork) {
        self.dreamWorld = dreamWorld
        self.officialArtwork = officialArtwork
    }
}

// MARK: - OfficialArtwork
public struct OfficialArtwork: Codable {
    public let frontDefault: String?

    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }

    public init(frontDefault: String) {
        self.frontDefault = frontDefault
    }
}

// MARK: - Stat
public struct Stat: Codable {
    public let baseStat, effort: Int
    public let stat: Species

    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case effort, stat
    }

    public init(baseStat: Int, effort: Int, stat: Species) {
        self.baseStat = baseStat
        self.effort = effort
        self.stat = stat
    }
}

// MARK: - TypeElement
public struct TypeElement: Codable {
    public let slot: Int
    public let type: Species

    public init(slot: Int, type: Species) {
        self.slot = slot
        self.type = type
    }
}
