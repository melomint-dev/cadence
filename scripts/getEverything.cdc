// This is the most basic script you can execute on Flow Network
import MeloMint from 0xdf939a7ccc83cb72

pub fun main(): Bool {

  return MeloMint.isCreatorExists(creatorId: 0)
}
