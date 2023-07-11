import MeloMint from "../contracts/MeloMint.cdc"

transaction {
  prepare(signer: AuthAccount) {
    let user1 = MeloMint.User(name: "Kavan", email: "kavan@gmail.com", type: "User", walletAddress: signer.address)
    
    MeloMint.addUser(user: user1)
  }

  execute {
    log(MeloMint.getUsers())
  }
}
