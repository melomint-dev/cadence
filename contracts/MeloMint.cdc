pub contract MeloMint {

  access(contract) var people: {Address: Person}
  access(contract) var songs: {String: Song}

  pub struct Person {
    pub var id: Address
    pub var firstName: String
    pub var lastName: String
    pub var img: String
    pub var type: Int      // 0 -> user, 1 -> artist
    pub var revenue: Int
    
    pub var subscribers: {Address: Bool}
    pub var subscribedTo: {Address: Bool}

    pub var NFTprice: Int
    pub var subscriptionTill: UFix64
    pub var likedSongs: {String: Bool}
    pub var songsPublished: {String: Bool}
    pub var recentlyHeard: [String]

    init(id: Address, firstName: String, lastName: String, type: Int) {
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

      self.likedSongs = {}  // will add from user side, but abt the creator side?
      self.songsPublished = {}  // no need for public function
      self.recentlyHeard = []
    }

    pub fun structUpdateImg(img: String) {
      self.img = img
    }

    pub fun structUpdateType(newType: Int) {
      self.type = newType
    }

    pub fun structUpdateRevenue(revenue: Int) {
      self.revenue = revenue
    }

    // TODO: securely update
    pub fun structAddSubscriber(userAddress: Address) {
      self.subscribers[userAddress] = true
    }

    // TODO: securely update
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

  pub fun updatePersonImage(person: AuthAccount, img: String) {
    self.people[person.address]!.structUpdateImg(img: img)
  }

  pub fun changePersonType(person: AuthAccount, newType: Int) {

    /*
      CHARGE THE PERSON
      TO CHANGE THE TYPE
      WE ALREADY HAVE AuthAccount
    */

    self.people[person.address]!.structUpdateType(newType: newType)
  }

  pub fun changePersonRevenue(person: AuthAccount, revenue: Int) {
    self.people[person.address]!.structUpdateRevenue(revenue: revenue)
  }

  pub fun changePersonNFTPrice(person: AuthAccount, price: Int) {
    self.people[person.address]!.structUpdateNFTprice(newPrice: price)
  }

  pub fun changePersonLikedSongs(person: AuthAccount, songId: String) {
    if self.isSongExists(songId: songId) {
      self.people[person.address]!.structAddToLikedSongs(songId: songId)
    }
  }

  pub fun addRecentlyHeard(person: AuthAccount, songId: String) {
    if self.isSongExists(songId: songId) {
      self.people[person.address]!.structAddToRecentlyHeard(songId: songId)
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

    pub fun structGetGoldSong(songId: String): String {
      return self.goldSongs[songId]!
    }

    pub fun structGetNFTSongs(songId: String): String {
      return self.NFTSongs[songId]!
    }

    pub fun structAddGoldSongs(songId: String, songHash: String) {
      self.goldSongs[songId] = songHash
    }

    pub fun structAddNFTSongs(songId: String, songHash: String) {
      self.NFTSongs[songId] = songHash
    }
  }

  pub fun newPerson(id: Address, firstName: String, lastName: String, type: Int): Person {
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

  pub fun newSong(id: String, name: String, artist: AuthAccount, freeUrl: String, img: String, bannerImg: String): Song? {
    if self.getPersonByAddress(id: artist.address).type == 1 {
      var song = Song(id: id, name: name, artist: artist.address, freeUrl: freeUrl, img: img, bannerImg: bannerImg)
      self.songs[id] = song
      self.people[artist.address]!.structSongPublished(songId: id)
      return song
    }
    return nil
  }

  pub fun getSongs(): {String: Song} {
    return self.songs
  }

  pub fun isSongExists(songId: String): Bool {
    return self.songs.containsKey(songId)
  }

  pub fun getSongById(songId: String): Song {
    return self.songs[songId]!
  }

  init() {
    self.people = {}
    self.songs = {}
  }
}