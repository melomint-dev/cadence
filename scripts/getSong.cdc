// This is the most basic script you can execute on Flow Network
import MeloMint from 0xd4701e0b1a6cb1e2

pub fun main(songId: UInt64): MeloMint.Song? {
  return MeloMint.getSongById(songId)
}
