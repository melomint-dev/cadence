// This is the most basic script you can execute on Flow Network
import MeloMint from 0x11e582a74930c1de

pub fun main(): {UInt64: MeloMint.Song} {
  return MeloMint.getSongs()
}
