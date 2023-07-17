pub contract MeloMint {

  access(account) var people: {Address: Person}
  access(account) var songs: {String: Song}

  pub let SongCollectionStoragePath: StoragePath
  pub let SongCollectionPrivatePath: PrivatePath

  pub let deployer: Address
  /*
  
  ADD ADMIN ADDRESSESS dictionary
  TO MAKE FEW 

  */

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
    pub var NFTimage: String
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
      self.NFTimage = ""
      self.subscriptionTill = 0.0

      self.likedSongs = {}  // will add from user side, but abt the creator side?
      self.songsPublished = {}  // no need for public function
      self.recentlyHeard = []
    }

    access(account) fun structUpdateImg(img: String) {
      self.img = img
    }

    access(account) fun structUpdateType(newType: Int) {
      self.type = newType
    }

    access(account) fun structUpdateRevenue(revenue: Int) {
      self.revenue = revenue
    }

    // TODO: securely update
    access(account) fun structAddSubscriber(userAddress: Address) {
      self.subscribers[userAddress] = true
    }

    // TODO: securely update
    access(account) fun structAddSubsribedTo(artistAddress: Address) {
      self.subscribedTo[artistAddress] = true
    }

    access(account) fun structUpdateNFTprice(newPrice: Int) {
      self.NFTprice = newPrice
    }

    access(account) fun structUpdateNFTImage(newNFTImage: String) {
      self.NFTimage = newNFTImage
    }

    access(account) fun structAddToLikedSongs(songId: String) {
      self.likedSongs[songId] = true
    }

    access(account) fun structSongPublished(songId: String) {
      self.songsPublished[songId] = true
    }

    access(account) fun structAddToRecentlyHeard(songId: String) {
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

  pub fun changePersonRevenue(signer: AuthAccount, personId: Address, revenue: Int) {
    if signer.address == self.deployer {
      self.people[personId]!.structUpdateRevenue(revenue: revenue)
    }
  }

  pub fun changeNFTPriceAndImage(person: AuthAccount, price: Int, newNFTImage: String) {
    self.people[person.address]!.structUpdateNFTprice(newPrice: price)
    self.people[person.address]!.structUpdateNFTImage(newNFTImage: newNFTImage)
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
    pub var length: UFix64
    pub var uploadedAt: UFix64

    // TODO
    // pre-release untill
    pub var preRelease: UFix64

    pub var similarSongs: {String: [String]} // original
    pub var similarTo: {String: [String]} // copied

    pub var likes: Int
    pub var plays: {String: Int}
    pub var playTime: {String: Int}

    init(id: String, name: String, artist: Address, img: String) {
      self.id = id
      self.name = name
      self.artist = artist
      self.freeUrl = ""
      self.img = img
      self.uploadedAt = getCurrentBlock().timestamp
      self.similarSongs = {}
      self.similarTo = {}
      self.likes = 0
      self.plays = {}
      self.playTime = {}
      self.length = 0.0
      self.preRelease = getCurrentBlock().timestamp
    }

    access(account) fun structAddSimilarSongs(songId: String, data: [String]) {
      self.similarSongs[songId] = data
    }

    access(account) fun structAddSimilarTo(songId: String, data: [String]) {
      self.similarTo[songId] = data
    }

    access(account) fun structAddLikes(like: Int) {
      self.likes = self.likes + like
    }

    access(account) fun structAddPlays(day: String, play: Int) {
      self.plays[day] = play
    }

    access(account) fun structAddPlayTime(day: String, playTime: Int) {
      self.playTime[day] = playTime
    }

    access(account) fun structUpdateSongLength(songLength: UFix64) {
      self.length = songLength
    }

    access(account) fun structUpdateFreeUrl(freeUrl: String) {
      self.freeUrl = freeUrl
    }

    access(account) fun structUpdateImg(img: String) {
      self.img = img
    }

    access(account) fun structPreRelease(preRelease: UFix64) {
      self.preRelease = preRelease
    }
  }

  pub fun songAddSimilarSongs(signer: AuthAccount, mySongId: String, myCopiedSongId: String, data: [String]) {
    if signer.address == self.deployer {
      self.songs[mySongId]!.structAddSimilarSongs(songId: myCopiedSongId, data: data)
    }
  }

  pub fun addSongSimilarTo(signer: AuthAccount, mySongId: String, originalSongId: String, data: [String]) {
    if signer.address == self.deployer {
      self.songs[mySongId]!.structAddSimilarTo(songId: originalSongId, data: data)
    }
  }

  pub fun songAddLikes(signer: AuthAccount, songId:String, like: Int) {
    if signer.address == self.deployer {
      self.songs[songId]!.structAddLikes(like: like)
    }
  }

  pub fun songAddPlays(signer: AuthAccount, songId: String, day: String, play: Int) {
    if signer.address == self.deployer {
      self.songs[songId]!.structAddPlays(day: day, play: play)
    }
  }

  pub fun songAddPlayTime(signer: AuthAccount, songId: String, day: String, playTime: Int) {
    if signer.address == self.deployer {
      self.songs[songId]!.structAddPlayTime(day: day, playTime: playTime)
    }
  }

  pub fun songUpdateLength(signer: AuthAccount, songId: String, length: UFix64) {
    if signer.address == self.deployer {
      self.songs[songId]!.structUpdateSongLength(songLength: length)
    }
  }

  pub fun songUpdateFreeUrl(signer: AuthAccount, songId: String, freeUrl: String) {
    if signer.address == self.deployer {
      self.songs[songId]!.structUpdateFreeUrl(freeUrl: freeUrl)
    }
  }

  pub fun songUpdateImg(signer: AuthAccount, songId: String, img: String) {
    if signer.address == self.deployer {
      self.songs[songId]!.structUpdateImg(img: img)
    }
  }  

  pub fun songUpdatePreRelease(signer: AuthAccount, songId: String, preRelease: UFix64) {
    self.songs[songId]!.structPreRelease(preRelease: preRelease)
  }

  pub resource SongCollection {
    pub var goldSongs: {String: String}
    pub var NFTSongs: {String: String}

    init() {
      self.goldSongs = {}
      self.NFTSongs = {}
    }

    pub fun isGoldSongExists(songId: String): Bool {
      return self.goldSongs.containsKey(songId)
    }    

    pub fun isNFTSongExists(songId: String): Bool {
      return self.NFTSongs.containsKey(songId)
    }

    pub fun getGoldSong(songId: String): String {
      return self.goldSongs[songId]!
    }

    pub fun getNFTSong(songId: String): String {
      return self.NFTSongs[songId]!
    }

    pub fun addGoldSong(songId: String, songHash: String) {
      self.goldSongs[songId] = songHash
    }

    pub fun addNFTSong(songId: String, songHash: String) {
      self.NFTSongs[songId] = songHash
    }
  }

  pub fun createSongCollection(): @SongCollection {
    return <- create SongCollection()
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

  pub fun newSong(id: String, name: String, artist: AuthAccount, img: String): Song? {
    if self.getPersonByAddress(id: artist.address).type == 1 {
      var song = Song(id: id, name: name, artist: artist.address, img: img)
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

  pub fun getDeployer(): Address {
    return self.deployer
  }

  init() {
    self.people = {}
    self.songs = {}

    self.deployer = self.account.address

    self.SongCollectionStoragePath = /storage/songCollection
    self.SongCollectionPrivatePath = /private/songCollection

    self.account.address
    self.account.save(<- self.createSongCollection(), to: self.SongCollectionStoragePath)

    log("Deployed")
  }
}
