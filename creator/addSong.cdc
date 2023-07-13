import MeloMint from 0x11e582a74930c1de

transaction(name: String, img: String, url: String) {
  prepare(signer: AuthAccount) {
    let creatorId = MeloMint.getCreatorIdByAddress(addr: signer.address)
    MeloMint.createSong(name: name, creator: signer.address, img: img, url: url, creatorId: creatorId!)
  }

  execute {
  }
}
