import MeloMint from 0xMeloMint

transaction (firstName: String, lastName: String, type: Int) {
  prepare(signer: AuthAccount) {
    MeloMint.newPerson(id: signer.address, firstName: firstName, lastName: lastName, type: type)
  }

  execute {
    log(MeloMint.getPeople())
  }
}