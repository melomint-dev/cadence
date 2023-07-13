pub contract MeloMint {

    pub let SongCollectionStoragePath: StoragePath
    pub let SongCollectionPrivatePath: PrivatePath

    access(contract) var users: {UInt64: User}
    access(contract) var creators: {UInt64: Creator}
    access(contract) var songs: {UInt64: Song}

    access(contract) var userAddresses: {Address: UInt64}
    access(contract) var creatorAddresses: {Address: UInt64}
    access(contract) var songAddresses: {Address: [UInt64]}

    access(contract) var userIdCount: UInt64
    access(contract) var creatorIdCount: UInt64
    access(contract) var songIdCount: UInt64

    pub struct User {
        pub var id: UInt64
        pub var name: String
        pub var email: String
        pub var img: String

        // map between creatorId and following
        pub var following: {UInt64: Bool}

        // list of songId recentlyHeard
        pub var recentlyHeard: [UInt64]

        // default User
        pub var type: String

        // list of all liked SongIds
        pub var likedSongs: [UInt64]

        pub var userAddress: Address

        init (name: String, email: String, type: String, userAddress: Address) {
            self.id = MeloMint.userIdCount
            self.name = name
            self.email = email
            self.img = ""
            self.following = {}
            self.recentlyHeard = []
            self.type = type
            self.likedSongs = []
            self.userAddress = userAddress
            MeloMint.userIdCount = MeloMint.userIdCount + 1
        }

        pub fun getName(): String {
            return self.name
        }

        pub fun addFollowing(creatorId: UInt64) {
            self.following[creatorId] = true
        }

        pub fun updateImage(img: String) {
            self.img = img
        }

        pub fun addToLikedSongs(songId: UInt64) {
            self.likedSongs.append(songId)
        }

        pub fun addToRecentlyHeard(songId: UInt64) {
            self.recentlyHeard.append(songId)
        }
    }

    pub fun createUser(name: String, email: String, type: String, userAddress: Address): User? {
        if MeloMint.userAddresses.containsKey(userAddress) {
            return MeloMint.getUserById(userId: MeloMint.getUserIdByAddress(addr: userAddress)!)
        }
        var newUser: MeloMint.User = User(name: name, email: email, type: type, userAddress: userAddress)
        self.users.insert(key: newUser.id, newUser)
        self.userAddresses.insert(key: userAddress, newUser.id)
        return newUser
    }

    pub struct Creator {
        pub var id: UInt64
        pub var name: String
        pub var email: String
        pub var type: String

        // map between userId and isFollower
        pub var follower: {UInt64: Bool}
        pub var price: UInt
        pub var img: String
        pub var creatorAddress: Address

        // a map between songId and the Song
        pub var songPublished: {UInt64: Bool}

        init(name: String, email: String, type: String, creatorAdress: Address) {
            self.songPublished = {}
            self.id = MeloMint.creatorIdCount
            self.name = name
            self.email = email
            self.type = type
            self.price = 0
            self.follower = {}
            self.img = ""
            self.creatorAddress = creatorAdress
            MeloMint.creatorIdCount = MeloMint.creatorIdCount + 1
        }

        pub fun addFollower(userId: UInt64) {
            self.follower[userId] = true
        }

        pub fun createSongCollection(): @SongCollection {
            return <-create SongCollection(ownerId: self.id)
        }

        pub fun updateImage(img: String) {
            self.img = img
        }

        pub fun updatePrice(newPrice: UInt) {
            self.price = newPrice
        }

        pub fun addToSongPublished(songId: UInt64) {
            self.songPublished[songId] = true
        }
    }

    pub fun addNewSong(creator: Creator, song: Song): Creator {
        creator.addToSongPublished(songId: song.id)
        return creator
    }

    pub fun updatePrice(creator: Creator, newPrice: UInt) {
        creator.updatePrice(newPrice: newPrice)
        self.creators[creator.id] = creator
    }

    pub fun CreateCreator(name: String, email: String, type: String, creatorAdress: Address): Creator? {
        if MeloMint.creatorAddresses.containsKey(creatorAdress) {
            return MeloMint.getCreatorById(creatorId: MeloMint.getCreatorIdByAddress(addr: creatorAdress)!)
        }
        var newCreator: MeloMint.Creator = Creator(name: name, email: email, type: type, creatorAdress: creatorAdress)
        self.creators.insert(key: newCreator.id, newCreator)
        self.creatorAddresses.insert(key: creatorAdress, newCreator.id)
        return newCreator
    }

    pub struct Song {
        pub let id: UInt64
        pub var name: String
        pub let creator: Address
        pub var numberOfLikes: UInt
        pub var img: String
        pub var createdAt: UFix64
        pub var url: String
        pub var similarSongs: [{UInt64: String}]

        init(name: String, creator: Address, img: String, url: String) {
            self.id = MeloMint.songIdCount
            self.name = name
            self.creator = creator
            self.numberOfLikes = 0
            self.img = img
            self.url = url
            self.createdAt = getCurrentBlock().timestamp
            self.similarSongs = []
            MeloMint.songIdCount = MeloMint.songIdCount + 1
        }

        pub fun addLike() {
            self.numberOfLikes = self.numberOfLikes + 1
        }

        pub fun addSimilarity (songId: UInt64, timestamp: String) {
            self.similarSongs.append({songId: timestamp})
        }
    }

    pub fun createSong(name: String, creator: Address, img: String, url: String, creatorId: UInt64): Song? {
        var newSong: MeloMint.Song = Song(name: name, creator: creator, img: img, url: url)
        let creatorStruct: MeloMint.Creator? = MeloMint.getCreatorById(creatorId: creatorId)
        MeloMint.creators[creatorStruct!.id] = MeloMint.addNewSong(creator: creatorStruct!, song: newSong)
        MeloMint.songs.insert(key: self.songIdCount, newSong)
        if MeloMint.songAddresses.containsKey(creator) {
            MeloMint.songAddresses[creator]!.append(newSong.id)
        } else {
            MeloMint.songAddresses.insert(key: creator, [newSong.id])
        }
        return newSong
    }
    
    pub resource interface SongReceiver {
        pub fun isSongExists(songId: UInt64): Bool
        pub fun getSongAsset(songId: UInt64): String
    }

    pub resource SongCollection: SongReceiver {

        pub let ownerId: UInt64

        // map between CreatorId and corresponding asset
        pub var songCollections: {UInt64: String}

        pub fun isSongExists(songId: UInt64): Bool {
            return self.songCollections[songId] != nil
        }

        pub fun getSongAsset(songId: UInt64): String {
            return self.songCollections[songId]!
        }

        pub fun addSong(addr: Address, songId: UInt64, audioAsset: String) {
            if (self.owner?.address == addr) {
                self.songCollections[songId] = audioAsset
            }
        }

        init (ownerId: UInt64) {
            self.songCollections = {}
            self.ownerId = ownerId
        }
    }

    pub fun getUsers(): {UInt64: User} {
        return self.users
    }

    pub fun isUserExists(userId: UInt64): Bool {
        return self.users[userId] != nil
    }

    pub fun getUserIdByAddress(addr: Address): UInt64? {
        return self.userAddresses[addr]
    }

    pub fun getUserById(userId: UInt64): User? {
        return self.users[userId]
    }

    pub fun getCreators(): {UInt64: Creator} {
        return self.creators
    }

    pub fun isCreatorExists(creatorId: UInt64): Bool {
        return self.creators[creatorId] != nil
    }

    pub fun getCreatorIdByAddress(addr: Address): UInt64? {
        return self.creatorAddresses[addr]
    }

    pub fun getCreatorById(creatorId: UInt64): Creator? {
        return self.creators[creatorId]
    }

    pub fun getSongs(): {UInt64: Song} {
        return self.songs
    }

    pub fun isSongExists(songId: UInt64): Bool {
        return self.songs[songId] != nil
    }

    pub fun getSongsIdByAddress(addr: Address): [UInt64]? {
        return self.songAddresses[addr]
    }

    pub fun getSongById(songId: UInt64): Song? {
        return self.songs[songId]
    }

    init() {
        self.users = {}
        self.creators = {}
        self.songs = {}
        self.userAddresses = {}
        self.creatorAddresses = {}
        self.songAddresses = {}
        self.creatorIdCount = 0
        self.songIdCount = 0
        self.userIdCount = 0

        self.SongCollectionStoragePath = /storage/songCollection
        self.SongCollectionPrivatePath = /private/songCollection
    }
}