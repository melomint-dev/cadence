import MeloMint from 0xdf939a7ccc83cb72

transaction(name: String, img: String, url: String) {
  prepare(signer: AuthAccount) {
    let creatorId = MeloMint.getCreatorIdByAddress(addr: signer.address)
    MeloMint.createSong(name: name, creator: signer.address, img: img, url: url, creatorId: creatorId)
  }

  execute {
    log(MeloMint.getSongs())
    log(MeloMint.getCreators())
  }
}
