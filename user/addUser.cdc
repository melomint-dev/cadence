import MeloMint from 0xdf939a7ccc83cb72

transaction(name: String, email: String, type: String) {
  prepare(signer: AuthAccount) {
    let newUser = MeloMint.createUser(name: name, email: email, type: type, userAddress: signer.address)
    log(MeloMint.getUserIdByAddress(addr: signer.address))
  }

  execute {
    log(MeloMint.getUsers())
  }
}
