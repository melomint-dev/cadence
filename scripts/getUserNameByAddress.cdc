// This is the most basic script you can execute on Flow Network
import MeloMint from 0xd4701e0b1a6cb1e2

pub fun main(addr: Address): String? {
  let userId = MeloMint.getUserIdByAddress(addr: addr)! + 1 as UInt64
  return MeloMint.getUserById(userId: userId!)?.getName()
}
