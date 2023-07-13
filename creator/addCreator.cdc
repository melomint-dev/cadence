import MeloMint from 0x11e582a74930c1de

transaction(name: String, email: String, type: String) {
  prepare(signer: AuthAccount) {
    MeloMint.CreateCreator(name: name, email: email, type: type, creatorAdress: signer.address)
  }

  execute {
  }
}