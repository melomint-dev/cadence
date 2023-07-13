// This is the most basic script you can execute on Flow Network
import MeloMint from 0xd4701e0b1a6cb1e2

pub fun main(): UInt64? {
  let creatorId = MeloMint.getCreatorIdByAddress(addr: 0x482c030acfdcb4cc)! + 1 as UInt64
  return creatorId
}

