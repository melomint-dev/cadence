import MeloMint from 0x11e582a74930c1de

transaction(price: UInt) {
  prepare(signer: AuthAccount) {
    let creatorId = MeloMint.getCreatorIdByAddress(addr: signer.address)!
    let creator = MeloMint.getCreatorById(creatorId: creatorId)
    // let creator = MeloMint.getCreatorById(creatorId: 0)
    MeloMint.updatePrice(creator: creator!, newPrice: price)
  }
}