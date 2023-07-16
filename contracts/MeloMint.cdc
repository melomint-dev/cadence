pub contract MeloMint {

  access(contract) var people: {Address: Person}
  access(contract) var songs: {String: Song}

  pub enum PersonType: UInt8 {
    pub case user
    pub case artist
  }

  pub struct Person {
    pub var id: Address
    pub var firstName: String
    pub var lastName: String
    pub var img: String
    pub var type: PersonType
    pub var revenue: Int
    
    pub var subscribers: {Address: Bool}
    pub var subscribedTo: {Address: Bool}

    pub var NFTprice: Int
    pub var subscriptionTill: UFix64
    pub var likedSongs: {String: Bool}
    pub var songsPublished: {String: Bool}
    pub var recentlyHeard: [String]

    init(id: Address, firstName: String, lastName: String, type: PersonType) {
      self.id = id
      self.firstName = firstName
      self.lastName = lastName
      self.img = ""
      self.type = type
      self.revenue = 0

      self.subscribers = {}
      self.subscribedTo = {}

      self.NFTprice = 0
      self.subscriptionTill = 0.0

      self.likedSongs = {}
      self.songsPublished = {}
      self.recentlyHeard = []
    }

    pub fun structUpdateImg(img: String) {
      self.img = img
    }

    pub fun structAddSubscriber(userAddress: Address) {
      self.subscribers[userAddress] = true
    }

    pub fun structAddSubsribedTo(artistAddress: Address) {
      self.subscribedTo[artistAddress] = true
    }

    pub fun structUpdateNFTprice(newPrice: Int) {
      self.NFTprice = newPrice
    }

    pub fun structAddToLikedSongs(songId: String) {
      self.likedSongs[songId] = true
    }

    pub fun structSongPublished(songId: String) {
      self.songsPublished[songId] = true
    }

    pub fun structAddToRecentlyHeard(songId: String) {
      self.recentlyHeard.append(songId);
    }
  }

  pub struct Song {
    pub var id: String
    pub var name: String
    pub var artist: Address
    pub var freeUrl: String
    pub var img: String
    pub var bannerImg: String
    pub var uploadedAt: UFix64

    pub var similarSongs: {String: [String]} // original
    pub var similarTo: {String: [String]} // copied

    pub var likes: Int
    pub var plays: {String: Int}
    pub var playTime: {String: Int}

    init(id: String, name: String, artist: Address, freeUrl: String, img: String, bannerImg: String) {
      self.id = id
      self.name = name
      self.artist = artist
      self.freeUrl = freeUrl
      self.img = img
      self.bannerImg = bannerImg
      self.uploadedAt = getCurrentBlock().timestamp
      self.similarSongs = {}
      self.similarTo = {}
      self.likes = 0
      self.plays = {}
      self.playTime = {}
    }

    pub fun structAddSimilarSongs(songId: String, data: [String]) {
      self.similarSongs[songId] = data
    }

    pub fun structAddSimilarTo(songId: String, data: [String]) {
      self.similarTo[songId] = data
    }

    pub fun structAddLikes(like: Int) {
      self.likes = self.likes + like
    }

    pub fun structAddPlays(day: String, play: Int) {
      self.plays[day] = play
    }
  }

  pub resource SongCollection {
    pub var goldSongs: {String: String}
    pub var NFTSongs: {String: String}

    init(collectionOwner: Address) {
      self.goldSongs = {}
      self.NFTSongs = {}
    }

    pub fun structAddGoldSongs(songId: String, songHash: String) {
      self.goldSongs[songId] = songHash
    }

    pub fun structAddNFTSongs(songId: String, songHash: String) {
      self.NFTSongs[songId] = songHash
    }
  }

  pub fun newPerson(id: Address, firstName: String, lastName: String, type: PersonType): Person {
    if self.isPersonExists(id: id) {
      return self.getPersonByAddress(id: id)
    }
    var person = Person(id: id, firstName: firstName, lastName: lastName, type: type)
    self.people[id] = person
    return person
  }

  pub fun isPersonExists(id: Address): Bool {
    return self.people.containsKey(id)
  }

  pub fun getPersonByAddress(id: Address): Person {
    return self.people[id]!
  }

  pub fun getPeople(): {Address: Person} {
    return self.people
  }

  pub fun newSong(id: String, name: String, artist: Address, freeUrl: String, img: String, bannerImg: String): Song {
    var song = Song(id: id, name: name, artist: artist, freeUrl: freeUrl, img: img, bannerImg: bannerImg)
    self.songs[id] = song
    self.getPersonByAddress(id: artist).structSongPublished(songId: song.id)
    return song
  }

  init() {
    self.people = {}
    self.songs = {}
  }
}