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

        // map between creatorId and following
        pub var following: {UInt64: Bool}
        pub var recentlyHeard: [UInt64]
        pub var type: String
        pub var likedSongs: [UInt64]
        pub var userAddress: Address

        init (name: String, email: String, type: String, userAddress: Address) {
            self.id = MeloMint.userIdCount
            self.name = name
            self.email = email
            self.following = {}
            self.recentlyHeard = []
            self.type = type
            self.likedSongs = []
            self.userAddress = userAddress
            MeloMint.userIdCount = MeloMint.userIdCount + 1
        }

        pub fun addFollowing(creatorId: UInt64, addr: Address) {
            if (addr == self.userAddress) {
                self.following[creatorId] = true
            }
        }
    }

    pub fun createUser(name: String, email: String, type: String, userAddress: Address): User {
        var newUser: MeloMint.User = User(name: name, email: email, type: type, userAddress: userAddress)
        self.users.insert(key: self.userIdCount, newUser)
        self.userAddresses.insert(key: userAddress, newUser.id)
        return newUser
    }

    pub struct Creator {
        pub var id: UInt64
        pub var name: String

        // map between userId and isFollower
        pub var follower: {UInt64: Bool}
        pub var price: UInt
        pub var img: String
        pub var creatorAddress: Address

        // a map between songId and the Song
        pub var songPublished: {UInt64: Bool}

        init(name: String, price: UInt, img: String, creatorAdress: Address) {
            self.songPublished = {}
            self.id = MeloMint.creatorIdCount
            self.name = name
            self.price = price
            self.follower = {}
            self.img = img
            self.creatorAddress = creatorAdress
            MeloMint.creatorIdCount = MeloMint.creatorIdCount + 1
        }

        pub fun addFollower(userId: UInt64, addr: Address) {
            if (addr == self.creatorAddress) {
                self.follower.insert(key: userId, true)
            }
        }

        pub fun createSongCollection(): @SongCollection {
            return <-create SongCollection(ownerId: self.id)
        }

        pub fun updatePrice(price: UInt, addr: Address) {
            if (addr == self.creatorAddress) {
                self.price = price
            }
        }

        pub fun addNewSong(song: Song, addr: Address) {
            log(song)
            if (addr == self.creatorAddress) {
                self.songPublished[song.id] = true
            }
        }
    }

    pub fun CreateCreator(name: String, price: UInt, img: String, creatorAdress: Address): Creator {
        var newCreator: MeloMint.Creator = Creator(name: name, price: price, img: img, creatorAdress: creatorAdress)
        self.creators.insert(key: self.creatorIdCount, newCreator)
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

        init(name: String, creator: Address, img: String, url: String) {
            self.id = MeloMint.songIdCount
            self.name = name
            self.creator = creator
            self.numberOfLikes = 0
            self.img = img
            self.url = url
            self.createdAt = getCurrentBlock().timestamp
            MeloMint.songIdCount = MeloMint.songIdCount + 1
        }
    }

    pub fun createSong(name: String, creator: Address, img: String, url: String, creatorId: UInt64): Song? {
        if creator == self.getCreatorById(creatorId: creatorId).creatorAddress {
            var newSong: MeloMint.Song = Song(name: name, creator: creator, img: img, url: url)
            self.getCreatorById(creatorId: creatorId).addNewSong(song: newSong, addr: creator)
            self.songs.insert(key: self.songIdCount, newSong)
            if self.songAddresses.containsKey(creator) {
                self.songAddresses[creator]!.append(newSong.id)
            } else {
                self.songAddresses.insert(key: creator, [newSong.id])
            }
            return newSong
        }
        return nil
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

    pub fun getUserIdByAddress(addr: Address): UInt64 {
        return self.userAddresses[addr]!
    }

    pub fun getUserById(userId: UInt64): User {
        return self.users[userId]!
    }

    pub fun getCreators(): {UInt64: Creator} {
        return self.creators
    }

    pub fun isCreatorExists(creatorId: UInt64): Bool {
        return self.creators[creatorId] != nil
    }

    pub fun getCreatorIdByAddress(addr: Address): UInt64 {
        return self.creatorAddresses[addr]!
    }

    pub fun getCreatorById(creatorId: UInt64): Creator {
        return self.creators[creatorId]!
    }

    pub fun getSongs(): {UInt64: Song} {
        return self.songs
    }

    pub fun isSongExists(songId: UInt64): Bool {
        return self.songs[songId] != nil
    }

    pub fun getSongsIdByAddress(addr: Address): [UInt64] {
        return self.songAddresses[addr]!
    }

    pub fun getSongById(songId: UInt64): Song {
        return self.songs[songId]!
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