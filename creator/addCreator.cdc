import MeloMint from 0xdf939a7ccc83cb72

transaction(name: String, price: UInt, img: String) {
  prepare(signer: AuthAccount) {
    MeloMint.CreateCreator(name: name, price: price, img: img, creatorAdress: signer.address)
    log(MeloMint.getCreatorIdByAddress(addr: signer.address))
  }

  execute {
    log(MeloMint.getCreators())
  }
}