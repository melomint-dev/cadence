import MeloMint from 0xMeloMint

pub fun main(songId: String): MeloMint.Song {
    return MeloMint.getSongById(songId: songId)
}