// This is the most basic script you can execute on Flow Network
import MeloMint from 0x7920a39831dafa62

pub fun main(): UInt64? {
  // let userId = MeloMint.getCreatorIdByAddress(addr: addr)! + 1 as UInt64
  return MeloMint.getCreatorIdByAddress(addr: 0xe409ccdf30d1b047)
}
